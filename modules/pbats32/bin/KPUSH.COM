�KPUSH v.2.0 (c) 1997, Horst Schaeffer
writes keys into keyboard buffer
Syntax:
 KPUSH [option] [keys]
 keys:  strings (single or double quotes)
	decimal ASCII values or CR,LF,BS,ESC
	non-ASCII keys with slash (/59=F1)
 option /F  flush buffer
	/E  extend buffer to 127
	/R  reset buffer to 15 keys

 KPUSH (only) for test mode

$+��
 �<��0:�s�� �F���
*��6m��tP���X��0�д�!ô���t��CRLF
BSES+ɀ<0r�<9w����Ë%�߻�;t
�����r��FF�O��u��$�<CuF�+�ì< t�<	t�<,t�N<u*��<'t<"u$��F8|t*���t�F8�t��p�t��*�FF��}��</uF�(��Ű�� �< t�N<*uF�����=�uKu���
Key test - ESC*2 to exit

ASCII	SCAN	Char
$�S�	�!+۴�<�u��v*�<u9�t^�؊�����	��!�����	��!��:]t�����r�ڴ�!�$�<��!���!�U��!�=Eu�C��!�>��!�~�	�!��P�@ ��X<Eu� ��  �	� �� > �� � � �Buffer space for $ keys
$�+�	�!P�@ ��X�� +� ��H���=�	�!�Extended MF2 mode only
$� �= u�j�	�!���i �� �< t�N<u����T �< t�<,t�N</u<�D<0r<9v1FF<?u��	�!�p��( $�<Et<Ru���]���<Fu*���!�<t���� *��L�!