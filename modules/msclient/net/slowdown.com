�rSLOWDOWN 2.00  Bret Johnson ���	             �� 6   d     ``11223344556677889900XXAA50                                                                                                            �������	�
��"�')�-�                    .:&#t#=u.�4��= �=u	.�4 �- .�.
�u���<u
�u��<u.�!�<u�ϜPQWV�;�_�$ �����F��^_YX��                   �PQ�����7 ��]�t(;�v+Ȁ>3�t
�3�� �����3�� ���3 YX�P�'�&(
�t@���u �>C u���%�����* s3����u��t�L ��t���� �̢'�&(X�P�a$<u��&���C�B���B��)���C�%�B���B�a�+�a�X�P���C�)�B���B�+�aX�PSQRWV��� Q.�1� &�61[�1���1+1u�;1t��r�C��t .�`��ă�� ������ҋ����1�&�>1+��!���� �0�0���.�&1�61X���1&�>1.�61� ����1�1&+1����>1 �
/�  �YIt�T��^_ZY[X�                   PSQ.�>$�un�@ �ؠ $�t$�:0uR�`���'
�tG:�t����>C t��W���J�>' u�w �>( u�(���aP��aX�a� � �Y[X�Y[X.�.T���
����2�2���C�؋�A�=�C;�v��Ã��+=s3�Ë;É;�C+��5�PSQR� �C+�����6C� �غ �@5��%ZY[X�                   �PS�= Ku@� t7�[ r�� r-3��i [X�U���v�]�.�a�S� �k [�� [X�.�.aPS3��d � s3��# ��O[X�QV� ��;t���������^YÜSQ��- �����s������r��GY[�ÜS���r	����G  [��P3�&�>4�u
���/�uC�X�fPSW��� 3����/�>,�.�u�>. t��,f�,�>. u=2 v���_[fX�                                                                                                                                           /C     �  �                                                                                          
Finished SLOWing DOWN:  SLOWDOWN is still installed in memory as a TSR.
 SLOWDOWN has been removed from memory.
 
 �J�!����� K�!�������&����[��>��t�5 ���� �!�� �x�� ��>��t�O2�
�t�� �� ��� �L�!PW�/�� �!�^� �	�Q� ���� _XÜSQRVU&�u&�m������� �&�7&�o]^ZY[��P2�����3���&9u&9Ot"&�� r&9Wu&9Ou���	&�_�����X�PS�?�u�KBu�G
�t<�u�	�t���[X�PS3۸�[XÀ>��t)S� �S� PQW��2������I)�t�@�!_YX[�                SLOWDOWN=  COMSPEC=SLOWDOWN         
Times as fast as an XT (speed=12 SU's):  
Times as fast as an AT (speed=54 SU's):  
Speed to use to simulate an XT (SU's) :  
Speed to Use to simulate an AT (SU's) :  
Speed currently REMEMBERED (SU's):       
MHz of an equivalent 80486:              
Maximum SPEED of this computer (SU's):   SLOWDOWN 2.00, (C) 1993-2000, Bret Johnson.
 Current Hot-Key Shift Mask:  Hot-Keys are currently Disabled. {none} <Shift> <Control> <Alt> -   Environment:  Current Windows Virtual-DOS-Machine ID (VMID):  Windows is not currently running. 
SLOWDOWN installed in memory.
Type SLOWDOWN /U to Uninstall.
 Another version of SLOWDOWN was found in memory.
Please UNINSTALL the other version before continuing.
 
Resident SLOWDOWN updated with new information.
 Memory error.
Unable to install SLOWDOWN into memory.
 Unable to remove SLOWDOWN from memory, but the SlowDown Factor is set to 0.
Remove any TSR's installed after SLOWDOWN and try again.
 Can't find SLOWDOWN in memory.
You must install it before it can be Uninstalled.
 
Current SPEED:     ( % of normal speed, or a  -MHz 80486)
 
This computer is not fast enough to use SLOWDOWN. 
Error in the Environment variable "SLOWDOWN":
 
Error in the command-line Options for SLOWDOWN:
 ^ Error

 Reset the Environment variable (type "SET SLOWDOWN=") and then
 Type "SLOWDOWN ?" for Help.
 
 MORE   (Press a key to continue)  MORE                             
SYNTAX:  [SLOWDOWN Options] [executable filename w/ options]
  /?,/H        � Show this HELP screen
  /U           � UNINSTALL from memory
  /Q  /V       � Be QUIET or VERBOSE about the details (default = VERBOSE)
  /E  /D       � ENABLE or DISABLE the Hot-Keys (default = ENABLE)
  /K:ShiftMask � Hot-KEY Shift Mask (default = Ctrl-Alt)

  /X[:nnn]   � Run the computer the same speed as an XT (4.77-MHz 8088)
  /A[:nnn]   � Run the computer the same speed as an AT (8-MHz 80286)
  /R[:nnn]   � Run the computer at the REMEMBERED Speed (default = 65535)
  /M:nnn     � Run the computer the same speed as a nnn-MHz 80486 (0-5000)
  /P:nnn.nn  � Run the computer at nnn.nn% of normal speed (0.00-100.00)
  /S:nnn     � Run the computer at a SPEED of nnn SU's (0-65535)
  /nnn       � Slow the computer Down by nnn SU's (0-65535) (default = 0)
  /T         � Show TABLE of various computer Speeds in SU's
 
����������������������������������������������������������������ͻ
�                         CPU Speed Table                        �
����������������������������������������������������������������͹
�     Computer Model      � CPU Mfg �  CPU Model  �  MHz � Speed �
����������������������������������������������������������������Ķ
� Generic                 � Intel   � 8088        � 4.77 �    12 �
� Generic                 � NEC     � V20         � 4.77 �    14 �
� Generic                 � Intel   � 80286       �    8 �    54 �
� Generic                 � AMD     � AMD386DX    �   20 �   123 �
� IBM ThinkPad 701C       � Intel   � 80486 DX/4  �   75 �   889 �
� Generic                 � AMD     � AM486DX4    �  100 �  1300 �
� Dell Optiplex GX1 350M+ � Intel   � Pentium-2   �  350 �  3640 �
� Generic                 � AMD     � K6-2        �  350 �  4780 �
����������������������������������������������������������������ͼ
         NOTE: Speed is measured in Slowdown-Units (SU's)
 HELP  H XTSPEED XTSPD XT XSPEED XSPD  X VERBOSE  V UNINSTALL  U TALK  V TABLEOFCPUSPEEDS TABLEOFCPUSPDS TABLEOFSPEEDS TABLEOFSPDS TABLE TBLOFCPUSPEEDS TBLOFCPUSPDS TBLOFSPEEDS TBLOFSPDS TBL  T SPEEDTABLE SPEEDTBL SPDTABLE SPDTBL  T SPEED SPD  S SHUTUP  Q SHIFTMASK SFTMASK  K REMOVE  U REMEMBERSPEED REMEMBERSPD REMEMBER REMSPEED REMSPD REM  R QUIET  Q PERCENT PCT  P OUT  U ON  E OFF  D MHZ486 MHZ  M KEYSHIFTMASK KEYSFTMASK KEYMASK KEY  K HOTKEYSHIFTMASK HOTKEYSFTMASK HOTKEYMASK HOTKEY  K ENABLEHOTKEYS ENABLEKEYS ENABLE  E DISABLEHOTKEYS DISABLEKEYS DISABLE  D CPUSPEEDTABLE CPUSPEEDTBL CPUSPDTABLE CPUSPDTBL  T ATSPEED ATSPD AT ASPEED ASPD  A  ?�"A�"D�"E�"H�"K�#MG#P$Q�"R�"S�#T�"U�"V�"X�" STRG STG   SHIFT SFT S   NULL NOTHING NONE NO NIL NADA EMPTY 0   CONTROL CTRL CTL CNTRL CNTL C   ALTGR ALT A    ��5�&��� t�
���/9�t�4��H�/��&�C��	)�s3ۉ�	����>��t&�>C w�V�� ����e�����3��L�>u-�>��u��@��2�����=��0���%��j � 1�!�x��ȣ������>��t������ ���������&����*�PSQRWVU�� ���3�3�3҈&#2��/<�u0�3��/�� �u/��/�� �u!��/;!t.��f�+�>�	 u�&#�&�	�&#��s��&�	�&#�����>��]^_ZY[X�PSQ�>��t��� ��������3���Y[XÀ>�	�u(�! �9 ��������	���� ���|���2���À>�	�u�" �	 �S2����PR�" r���< 9�w�Z�G��X �] t����9�ZX�PSR� D� �!r�� t	�� t���Z[X�SQ�@ �ش����t�� u3��� �� @Y[�P� u�Xô�t2���3���PSR�13ۉ[�Y�A�?�;�CPP;7r��+7�Y3һ ��?X;9r��+9�[3һ6 ��AX;5r+5�;.�>� t�C.+�	s3�.����� Z[X�PSQRWV���t:�C.�>�	;�t-��� �9�t@= v��+D9�t)�r3���؉D����^_ZY[X�PSQRW3�&�C����+��d �������3�������;�r	@=d rG3������.������_ZY[X�SR�K ��y����;�r@Z[�QRW3�����S�L3���	 �>�	r�� �_�A�>�	r���S����ȱ��������_ZY�                   .��	.�.VPSQRVW�E&�C�	 �
 �������r@�Nu�&�  ��3����r@�u@&�=��&�C)�&�]^_ZY[X�PR�>��t�>�	�tS�>�	�tL&�>$�t�����,�d��&�02�
�u��������t� ���t� ���t�	 �x�~�ZX�
�tR���p�Z���j��PSR&�>4�t��X�����P������_�x�B�Z[X��< t$��	���	�����	 �������� �x����	 ��	�����	 ���SQWV�, ��	�þ�	� ��	�p ��	�	 ��	�d � ^_Y[�� ��PQWV�0�!<r?�, �؎�3����3��= u��} t$������	3ɬ<.t<\t����A��2��.��	^_YX�W3�QV�tG&�= u�&�= t^YG��^Y�?�^Y�G  _�PWV���6�	�, ��
�u�^_X�P2��P��>�	 tR��	��	��	
�t�����ZXÀ>��tfPQRV�
�?� &���������+��7� &���������+������+&�5��&�C���������+&�C�����x��^ZYXÀ>��tN�>��t�>�	�t@�>�	�t9PSQR&�C��+��غ�a��u�+�X��X��/�O�����^�H�A�ZY[X�PQRWV�� �>�	�u�6�	�Sr	tA�� u��/�|� u)��	 N�!����t�<t�����>�	�t��� ��
��^_ZYX�PQRW3�VB+��^<t�< t��>�	�t0����������	���� ��������E� ��΁� �	������[���+�	��	� I�x�}��� ���r������j�>�	�u���]�<�W�_ZYX�PS�]rHN�I�s(���tN�r.&�C9�v�À>�	�t!�i�����'
�t:�t�����W���	��>�	�[X�&�$ �&�$����	��������	����	���� �SW�Y�7�SW�[�9�SW�;�5P�es�>�	�t/�>�	�t-&�����%N�r�>�	�t&�&�>C)�s3�&�?���	�X_[�PSR�>�	�t.�r)N��r#=�w�y��K ����;�r@&�C)�s3����	���>�	�t���k�Z[X�PS�>�	�t��rN�r&�C)�s3����	���>�	�t���3�[X�PSQ�r)N2ɻ �r��u
��� <-t�N
�t��t���
�t��	���>�	�t&�0Y[X�PSR�>�	�t$�IrN�0 r�')�&�C��'����;�r
@���	��
�>�	�t��Z[X�SQR3�3��� sN�X rQ<.t�K=d wF���	<.tN�+�� �t"N��� =c w'��;�w t
�����؋��N�d ���='w���ZY[��� < t�<t����P���r	</t<?uN<���	��X�SR�Ѐ? t42�V� �:t��C�? u�C
�t^�? uۃ���XK�C�u�C������Z[�SQR3�3۹
 ��r#,0<	wN�< ,02�;�s���r<w��������N���ZY[��R�r<:t<=u�E�sN���À>�	�u��>�	 tS��	��&�F[
�u����PS2��,PS2��PS�=
 r��=d r��=�r��='r���PS2�QRW�
PW�  ��u�00��_X2��'3����u	
�u��u�ǈ�0��t��P3҉ȹ
 ���XG�Ѻ
2���k�_ZY[X�PW���� �	�Q� �!�^� �/�� _X�PSR� �5�!�]�E�����%�!Z[X����E��EKB�E	 �E
��À>�	�uU�>��u>3��Q߰���B r7�	�R�8 r-�!�_�. r#�/��$ r�I�!r��O2���������<�����SQ���1�Y[�P�, ���I�!s����X�<ar<zw, �P2�<0r<9w��
�X�PR� ��� 8Ԋ�t���u�ZX�PQ2��
�t�@ ����p �YX�