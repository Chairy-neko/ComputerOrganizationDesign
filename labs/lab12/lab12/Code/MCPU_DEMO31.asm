//�����ڵ���DEMO�����򣬹��ο���
.text 0x0000
	j	start									// 0
	add	$zero, $zero, $zero		// 4
	add	$zero, $zero, $zero		// 8
	add	$zero, $zero, $zero		// C
	add	$zero, $zero, $zero		// 10
	add	$zero, $zero, $zero		// 14
	add	$zero, $zero, $zero		// 18
	add	$zero, $zero, $zero		// 1C
start:
	lui  $v1, 0xf000	//����IO�˿ڵ�ַ��$v1=SW/LED��ַ=F00000000
	addi $s4, $zero, 0x3f	//���ó���3F
	lui  $t0, 0x8000	//��ȡCounter0_OUT����
	add  $a0, $v1, $v1	//����IO�˿ڵ�ַ,$a0=7-seg��ַ=E00000000
	addi $v0, $zero, 1	//����$v0=1
	nor  $at, $zero, $zero	//����FFFFFFFFF
	add  $t2, $at, $zero	
	addi $a3, $zero, 3
	nor  $a3, $a3, $a3	//$a3=FFFFFFFC
	addi $a2, $zero, 0x7fff	//$a2=0000ffff, ������ֵ
	add  $s1, $zero, $zero	//$s1=00000000,��ʼ��7��ͼ�����ݻ���ַ
loop1:	
	addi $a1, $zero, 0x2AB	//$a1=000002AB=����1010101011
	sw   $a1, 0x0($v1)	// ���ü�����ͨ��counter_set=11���ƶ˿ں�LED��ʼ��ֵ�� {GPIOf0[21:0],LED,counter_set} 
	addi $s2, $zero, 2	// XX M2 M1 M0 X
//	add  $s2, $s2, $s2	// XX M2 M1 M0 X
	sw   $zero, 4($v1)	//���������������,ѡ��ͨ��00

	lw   $a1, ($v1)		//����SW���ص�״̬:{out0��out1��out2��D28-D20��LED7-LED7��BTN3-BTN0��SW7-SW0}
	add  $a1, $a1, $a1	//����SW������LED���
	add  $a1, $a1, $a1	//���ּ���ͨ��0������SW����=LED���
	sw   $a1, ($v1)		//���ü�����ͨ��counter_set=00���ƶ˿ڡ�LED=SW�� {GPIOf0[21:0],LED,counter_set} 
	sw   $a2, 4($v1)	// counter ch0 :f0000004��������ַ����0x7fff��ʼ����������һֱ��00000000Ϊֹ
	lui  $t5, 0xFFFF	// $t5=FFFF0000

loop2:
	lw   $a1, 0($v1)	//����SW���ص�״̬:{out0��out1��out2��D28-D20��LED7-LED7��BTN3-BTN0��SW7-SW0}
	add  $a1, $a1, $a1	//����SW������LED���
	add  $a1, $a1, $a1	//���ּ���ͨ��0������SW����=LED���
	sw   $a1, 0($v1)	//���ü�����ͨ��counter_set=00���ƶ˿ڡ�LED=SW�� {GPIOf0[21:0],LED,counter_set} 
	lw   $a1, 0($v1)	//�ض�F00000000�˿�
	and  $t3, $a1, $t0	//��ȡCounter0_out��$t0=80000000
	addi $t5, $t5, 1	//����(���)������ʱ
	beq  $t3, $t0, C_init	//���������ʱ�������޸�7������ʾ


// -------------------------------------------------------

l_next: 			// �ж�7������ʾģʽ��SW[4:3]����
	lw   $a1, 0($v1)
	addi $s2, $zero, 0x18	// $18=00000018(00011000)
	and  $t3, $a1, $s2	// 
	
	beq  $t3, $zero,L00 	// SW[4:3]=00,7����ʾ"��"ѭ����λ��L))��SW0=0
	beq  $t3, $s2, L11 	// SW[4:3]=11����ʾ�߶�ͼ�Σ�L11��SW0=0
	addi $s2, $zero, 8	// $s2=8=00001000
	beq  $t3, $s2, L01 	//SW[4:3]=01,�߶���ʾԤ�����֣�L01��SW0=1
	sw   $t1, ($a0) 	//SW[4:3]=10����ʾr9��SW0=1
	j    loop2
// ------------------------------------------------------

L00:
	beq  $t2, $at,  l4	// $10=ffffffff, ת��L4
	j    l3
l4:
	nor  $t2, $zero, $zero	// $10=ffffffff
	add  $t2, $t2, $t2	// $10=fffffffe
l3:
	sw   $t2, ($a0)		//SW[4:3]=00,7����ʾ����λ����ʾ
	j    loop2

L11:
	lw   $t1, 0x2A0($s1)
	sw   $t1, ($a0)		//SW[4:3]=11����ʾ�߶�ͼ��
	j    loop2

L01:
	lw   $t1, 0x260($s1)
	sw   $t1, ($a0)		//SW[4:3]=01,�߶���ʾԤ������
	j    loop2

//�����������޸���ʾ�ͼ�������-----------------------------------------------
C_init:
	lui  $t5, 0xffff

	add  $t2, $t2, $t2	// $10=fffffffc��7��ͼ�ε�����
	or   $t2, $t2, $v0	//r10ĩλ��1����Ӧ���Ͻǲ���ʾ

	addi $s1, $s1, 4	//r17=00000004��LEDͼ�ηô��ַ+4
	and  $s1, $s1, $s4	//r17=000000XX�����ε�ַ��λ��ֻȡ6λ

//	add  $t1, $t1,$t1	//r9����
	addi $t1, $t1, 1	//r9+1
	beq  $t1, $at, l6	//��r9=ffffffff,����r9=5
	j    l7;
l6:
	addi $t1, $t1, 5	// $9=00000005

l7:
	lw   $a1, 0($v1)
	add  $t3, $a1, $a1	//����SW������LED���
	add  $t3, $t3, $t3	//���ü���ͨ��0������SW����=LED���
	sw   $t3, 0($v1)	//���ü���ͨ��0
	sw   $a2, 4($v1)
C_start:
	lw   $a1, ($v1)
	and  $t3, $a1, $t0
	beq  $t3, $t0, C_start
	j    l_next
	
.data 0x240
.word 0xf0000000, 0x000002AB, 0x80000000, 0x0000003F, 0x00000001, 0xFFFF0000, 0x0000FFFF, 0x80000000
.word 0x00000000, 0x11111111, 0x22222222, 0x33333333, 0x44444444, 0x55555555, 0x66666666, 0x77777777
.word 0x88888888, 0x99999999, 0xaaaaaaaa, 0xbbbbbbbb, 0xcccccccc, 0xdddddddd, 0xeeeeeeee, 0xffffffff 
.word 0x557EF7E0, 0xD7BDFBD9, 0xD7DBFDB9, 0xDFCFFCFB, 0xDFCFBFFF, 0xF7F3DFFF, 0xFFFFDF3D, 0xFFFF9DB9 
.word 0xFFFFBCFB, 0xDFCFFCFB, 0xDFCFBFFF, 0xD7DB9FFF, 0xD7DBFDB9, 0xD7BDFBD9, 0xFFFF07E0, 0x007E0FFF
.word 0x03bdf020, 0x03def820, 0x08002300