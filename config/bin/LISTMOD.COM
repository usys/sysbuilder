���V���$:�tF��u�:�^�    �       
 +�*����0��
s	F�&%���ÿ��K��9:u�0��u�Ë ��<t�F����"�?tC����u;�s۬<t֪���Ȉ�*ɬ<t��t�t�N��<t��f�u�N:�t���߇�;�s;�s���Ë6�< uF�<u�<$t���<u�<$t<)u�>�<(u�<�<!u�|���<Lt<lu�
���<#uV����^�<*u+��,0<	w���0��	wF�&%�V���!�^�N�녾� �6�< t�N</t�F�$߿�<St<Xu���< t����r�����<Nu+ۀ80r�89wC���㷈����<Pu����tH� �<,t�N�|��"�<Eu�$놺��z)ѻ �@�!���L�!�k�� D+��!���u܉�- ��&�)�+ۉ�?�!rω�ǉ>;�s�}�uO�
9E�t�����< t�N<tf<u�>$Eu'�&W��Z;�v	�}� uO��
���)ѻ �@�!������<t-<u��<
uF�9u�+ց� w�����ڻ  ��B�!�\�� �>�!*��2� ,;=001Invalid option

LISTMOD 2.3 (c) 1997, Horst Schaeffer
Syntax: LISTMOD [options] string < source > product
String may include tokens:
 $1...$99	for word 1..99 of source line
 $0 or $*	complete source line
 $( $! $) $$	< | > $
 $#		line count (default: 3 digits)
 $L		new Line
Options:
	/S..	separators, in addition to space and ,;=
	/Nnn..	initial line count for $# (default: 001)
	/Pc,l	only from c=column(1..), l=length
	/E	don't ignore empty lines
