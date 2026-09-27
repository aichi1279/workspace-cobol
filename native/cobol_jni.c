#include <jni.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include <libcob.h>

JNIEXPORT jstring JNICALL
Java_com_example_demo_CobolNative_callHello(
        JNIEnv *env,
        jobject obj,
        jstring jname)
{
    const char *name;

    char input[100];
    char output[101];

    void *argv[2];

    int ret;

    /*
     * Java String → C String
     */
    name = (*env)->GetStringUTFChars(env, jname, NULL);

    if (name == NULL) {
        return NULL;
    }

    /*
     * COBOLのPIC X(100)に合わせる
     */
    memset(input, ' ', sizeof(input));
    memset(output, ' ', sizeof(output));
    output[100] = '\0';

    strncpy(input, name, sizeof(input));

    /*
     * Java Stringを解放
     */
    (*env)->ReleaseStringUTFChars(env, jname, name);

    /*
     * GnuCOBOL Runtime初期化
     */
    cob_init(0, NULL);

    /*
     * COBOLに渡す引数
     */
    argv[0] = input;
    argv[1] = output;

    /*
     * COBOLプログラム呼び出し
     *
     * hello_cobol
     */
    ret = cob_call(
        "HELLO-COBOL",
        2,
        argv
    );

    if (ret != 0) {
        return (*env)->NewStringUTF(
            env,
            "COBOL program returned an error"
        );
    }

    /*
     * COBOLの結果をJava Stringへ
     */
    return (*env)->NewStringUTF(
        env,
        output
    );
}