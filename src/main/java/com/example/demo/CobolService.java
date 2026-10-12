package com.example.demo;

import org.springframework.stereotype.Service;

import java.nio.charset.StandardCharsets;
import java.util.concurrent.TimeUnit;

@Service
public class CobolService {

    public String hello(String name)  {

        try {
            
            // ProcessBuilder処理        
            ProcessBuilder pb = new ProcessBuilder(
                "/workspace/native/cobol_wrapper"
            );

            /*
            * GnuCOBOLのCALL対象を探す場所
            */
            pb.environment().put(
                "COB_LIBRARY_PATH",
                "/workspace/native"
            );

            /*
            * stderrはJavaプロセスのstderrへ流す
            */
            pb.redirectError(ProcessBuilder.Redirect.INHERIT);

            Process process = pb.start();

            try {
                /*
                * Wrapperのstdinへ名前を渡す
                */
                try (var writer = process.outputWriter(
                        StandardCharsets.UTF_8)) {

                    writer.write(name);
                    writer.newLine();
                }

                /*
                * 最大5秒待つ
                */
                boolean finished = process.waitFor(
                    5,
                    TimeUnit.SECONDS
                );

                if (!finished) {
                    process.destroyForcibly();
                    process.waitFor();

                    throw new IllegalStateException(
                        "COBOL process timeout"
                    );
                }

                /*
                * 終了コード確認
                */
                int exitCode = process.exitValue();

                if (exitCode != 0) {
                    throw new IllegalStateException(
                        "COBOL process failed. exitCode="
                        + exitCode
                    );
                }

                /*
                * Wrapperの標準出力を取得
                */
                return new String(
                    process.getInputStream().readAllBytes(),
                    StandardCharsets.UTF_8
                ).trim();

            } catch (InterruptedException e) {

                process.destroyForcibly();
                process.waitFor();

                Thread.currentThread().interrupt();

                throw e;

            } finally {

                if (process.isAlive()) {
                    process.destroyForcibly();
                }
            }

        }catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IllegalStateException("COBOL process interrupted", e);

        } catch (Exception e) {
            throw new IllegalStateException("COBOL execution failed", e);
        }
    }
}