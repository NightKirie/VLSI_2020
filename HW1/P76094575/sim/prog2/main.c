int main() {
    extern int mul1;
    extern int mul2;
    extern int _test_start;
    int a = mul1;
    int b = mul2;
    long long a_long = ((long long)a << 32) >> 32;
    long long b_long = ((long long)b << 32) >> 32;
    long long mul_a_b_long = a_long * b_long;
    *(&_test_start) = (int)mul_a_b_long;
    *(&_test_start + 1) = (int)(mul_a_b_long >> 32);
}
