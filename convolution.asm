.data
input_file: .asciiz "C:/Users/cclem/Downloads/Sample_test/Sample_test/Test_1/input_matrix.txt"
output_file: .asciiz "C:/Users/cclem/Downloads/Sample_test/Sample_test/Test_1/output_matrix.txt"

params: .align 2           # 4 số nguyên: N, M, p, s (4 byte mỗi số)
image: .align 2            # Ma trận image
kernel: .align 2           # Ma trận kernel
out: .align 2              # Ma trận kết quả

.text
main:
    # Mở file đầu vào
    li $v0, 13
    la $a0, input_file
    li $a1, 0               # Chế độ đọc
    li $a2, 0
    syscall
    move $s0, $v0           # Lưu file descriptor

    # Đọc 4 số đầu tiên (N, M, p, s)
    li $v0, 14
    move $a0, $s0
    la $a1, params          # Đảm bảo địa chỉ căn chỉnh đúng
    li $a2, 16
    syscall

    # Lấy thông số từ params
    la $t0, params
    lw $t1, 0($t0)          # $t1 = N (kích thước image)
    lw $t2, 4($t0)          # $t2 = M (kích thước kernel)
    lw $t3, 8($t0)          # $t3 = p (padding)
    lw $t4, 12($t0)         # $t4 = s (stride)

    # Đọc ma trận image
    li $v0, 14
    move $a0, $s0
    la $a1, image           # Đảm bảo địa chỉ căn chỉnh đúng
    mul $a2, $t1, $t1       # Kích thước image = N * N
    mul $a2, $a2, 4
    syscall

    # Đọc ma trận kernel
    li $v0, 14
    move $a0, $s0
    la $a1, kernel          # Đảm bảo địa chỉ căn chỉnh đúng
    mul $a2, $t2, $t2       # Kích thước kernel = M * M
    mul $a2, $a2, 4
    syscall

    # Đóng file đầu vào
    li $v0, 16
    move $a0, $s0
    syscall

    # Tính toán kích thước ma trận output
    sub $t5, $t1, $t2       # output size = (N - M + 1) / stride
    add $t5, $t5, 1
    div $t5, $t5, $t4
    move $a3, $t5           # $a3 = kích thước output

    # Tích chập và xử lý...

    # Ghi file output
li $v0, 13
la $a0, output_file
li $a1, 1
li $a2, 0
syscall
move $s0, $v0

# Thử ghi một vài giá trị vào ma trận out để kiểm tra
li $t0, 1
sw $t0, 0(out)       # Ghi số 1 vào vị trí đầu tiên của ma trận out
sw $t0, 4(out)       # Ghi số 1 vào vị trí thứ hai của ma trận out

# Syscall để ghi dữ liệu vào file output
li $v0, 15
move $a0, $s0
la $a1, out
mul $a2, $a3, $a3    # Số lượng phần tử trong ma trận out
mul $a2, $a2, 4      # Kích thước byte
syscall


    # Đóng file output
    li $v0, 16
    move $a0, $s0
    syscall

    # Kết thúc
    li $v0, 10
    syscall
