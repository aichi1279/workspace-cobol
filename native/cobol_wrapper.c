#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <libcob.h>

int main(void)
{
    char input[100];
    char output[100];

    void *argv[2];

    int ret;

    /*
     * 標準入力から名前を取得
     * JavaのProcessBuilderから渡される
     */
    memset(input, ' ', sizeof(input));

    if (fgets(input, sizeof(input), stdin) == NULL) {
        fprintf(stderr, "Failed to read input\n");
        return 1;
    }

    /*
     * 改行を除去
     */
    input[strcspn(input, "\r\n")] = ' ';

    /*
     * COBOLのOUT-MESSAGE用領域
     */
    memset(output, ' ', sizeof(output));

    /*
     * GnuCOBOL Runtime初期化
     */
    cob_init(0, NULL);

    /*
     * COBOLへ渡す引数
     */
    argv[0] = input;
    argv[1] = output;

    /*
     * HELLO-COBOLを呼び出す
     */
    ret = cob_call(
        "HELLO-COBOL",
        2,
        argv
    );

    /*
     * COBOL側がエラーを返した場合
     */
    if (ret != 0) {
        fprintf(
            stderr,
            "COBOL program returned error: %d\n",
            ret
        );

        cob_tidy();
        return 1;
    }

    /*
     * COBOLのOUT-MESSAGEを標準出力へ
     *
     * PIC X(100)なので100バイト出力
     */
    fwrite(output, 1, sizeof(output), stdout);
    fputc('\n', stdout);

    fflush(stdout);

    /*
     * GnuCOBOL Runtime終了
     */
    cob_tidy();

    return 0;
}