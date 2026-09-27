# COBOLコンパイル
# hello_cobol.cobをコンパイルし、hello_cobol.soを生成するためのコンパイルコマンド
cobc -m -o HELLO-COBOL.so hello_cobol.cob

# COBOLコンパイル後の環境変数設定
cd native
export COB_LIBRARY_PATH=$(pwd)


# Cコンパイル
# cobol_jni.cをコンパイルし、libcoboljni.soを生成するためのコンパイルコマンド
gcc \
  -fPIC \
  -I"$JAVA_HOME/include" \
  -I"$JAVA_HOME/include/linux" \
  -shared \
  -o libcoboljni.so \
  cobol_jni.c \
  -lcob



# Javaアプリケーションコンパイル＆実行方法
mvn spring-boot:run \
  -Dspring-boot.run.jvmArguments="-Djava.library.path=/workspace/native"