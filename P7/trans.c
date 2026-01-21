/* transpose function of 32 x 32*/
void transpose_32x32(int M, int N, int A[N][M], int B[M][N]) {
    /* Your Code Here [1/3] */
    int i, j, k;
    int a0,a1,a2,a3,a4,a5,a6,a7;
    for (i = 0; i < N; i += 8) {
        for (j = 0; j < M; j += 8) {
            if (i == j) {
                for (k = 0; k < 8; k++) {
                    a0 = A[i+k][j+0];
                    a1 = A[i+k][j+1];
                    a2 = A[i+k][j+2];
                    a3 = A[i+k][j+3];
                    a4 = A[i+k][j+4];
                    a5 = A[i+k][j+5];
                    a6 = A[i+k][j+6];
                    a7 = A[i+k][j+7];

                    B[j+0][i+k] = a0;
                    B[j+1][i+k] = a1;
                    B[j+2][i+k] = a2;
                    B[j+3][i+k] = a3;
                    B[j+4][i+k] = a4;
                    B[j+5][i+k] = a5;
                    B[j+6][i+k] = a6;
                    B[j+7][i+k] = a7;
                }
            } else {
                for (k = i; k < i + 8; k++) {
                    a0 = A[k][j+0];
                    a1 = A[k][j+1];
                    a2 = A[k][j+2];
                    a3 = A[k][j+3];
                    a4 = A[k][j+4];
                    a5 = A[k][j+5];
                    a6 = A[k][j+6];
                    a7 = A[k][j+7];

                    B[j+0][k] = a0;
                    B[j+1][k] = a1;
                    B[j+2][k] = a2;
                    B[j+3][k] = a3;
                    B[j+4][k] = a4;
                    B[j+5][k] = a5;
                    B[j+6][k] = a6;
                    B[j+7][k] = a7;
                }
            }
        }
    }
}

/* transpose function of 64 x 64*/
void transpose_64x64(int M, int N, int A[N][M], int B[M][N]) {
    int i, j, k;
    int a0, a1, a2, a3, a4, a5, a6, a7;
    int t0, t1, t2, t3;

    for (i = 0; i < N; i += 8) {
        for (j = 0; j < M; j += 8) {
            // 上半部分4行：直接转置前4列和后4列到B中对应位置
            for (k = 0; k < 4; k++) {
                a0 = A[i+k][j+0];
                a1 = A[i+k][j+1];
                a2 = A[i+k][j+2];
                a3 = A[i+k][j+3];
                a4 = A[i+k][j+4];
                a5 = A[i+k][j+5];
                a6 = A[i+k][j+6];
                a7 = A[i+k][j+7];

                // 前4列直接转置过去（top-left）
                B[j+0][i+k] = a0;
                B[j+1][i+k] = a1;
                B[j+2][i+k] = a2;
                B[j+3][i+k] = a3;

                // 后4列先写入 top-right（会在下一步与 lower-left 交换）
                B[j+0][i+k+4] = a4;
                B[j+1][i+k+4] = a5;
                B[j+2][i+k+4] = a6;
                B[j+3][i+k+4] = a7;
            }

            // 处理下半4行：与上一步写入的 top-right 交换，并写入 bottom-right
            for (k = 0; k < 4; k++) {
                // 保存之前写入的 top-right 的一列（防止覆盖）
                t0 = B[j+k][i+4];
                t1 = B[j+k][i+5];
                t2 = B[j+k][i+6];
                t3 = B[j+k][i+7];

                // 从 A 的下半左侧读出（lower-left）
                a0 = A[i+4][j+k];
                a1 = A[i+5][j+k];
                a2 = A[i+6][j+k];
                a3 = A[i+7][j+k];

                // 把 lower-left 放到 top-right（完成这些位置的最终转置）
                B[j+k][i+4] = a0;
                B[j+k][i+5] = a1;
                B[j+k][i+6] = a2;
                B[j+k][i+7] = a3;


                B[j+4+k][i+0] = t0;
                B[j+4+k][i+1] = t1;
                B[j+4+k][i+2] = t2;
                B[j+4+k][i+3] = t3;

                // 最后把 A 的下半右侧（lower-right）写入 bottom-right
                a4 = A[i+4][j+4+k];
                a5 = A[i+5][j+4+k];
                a6 = A[i+6][j+4+k];
                a7 = A[i+7][j+4+k];

                B[j+4+k][i+4] = a4;
                B[j+4+k][i+5] = a5;
                B[j+4+k][i+6] = a6;
                B[j+4+k][i+7] = a7;
            }
        }
    }
}

/* transpose function of 61 x 67*/
void transpose_61x67(int M, int N, int A[N][M], int B[M][N]) {
    /* Your Code Here [3/3] */
    int i, j, x, y;
    for (i = 0; i < N; i += 16) {
        for (j = 0; j < M; j += 16) {
            for (x = i; x < i + 16 && x < N; x++) {
                for (y = j; y < j + 16 && y < M; y++) {
                    B[y][x] = A[x][y];
                }
            }
        }
    }
}


