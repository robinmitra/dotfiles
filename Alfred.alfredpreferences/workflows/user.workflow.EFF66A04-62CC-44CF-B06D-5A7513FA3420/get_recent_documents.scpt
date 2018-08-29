FasdUAS 1.101.10   ��   ��    k             l     ��  ��    N H Looks for a sequence of bytes that identifies the path separator in the     � 	 	 �   L o o k s   f o r   a   s e q u e n c e   o f   b y t e s   t h a t   i d e n t i f i e s   t h e   p a t h   s e p a r a t o r   i n   t h e   
  
 l     ��  ��    P J file-bookmark's data. We can use this to find the start of the file path.     �   �   f i l e - b o o k m a r k ' s   d a t a .   W e   c a n   u s e   t h i s   t o   f i n d   t h e   s t a r t   o f   t h e   f i l e   p a t h .      l     ��  ��    8 2 Returns the start posiiton of the path separator.     �   d   R e t u r n s   t h e   s t a r t   p o s i i t o n   o f   t h e   p a t h   s e p a r a t o r .      i         I      �� ���� &0 findpathseparator findPathSeparator      o      ���� 0 thedata theData   ��  o      ���� 0 thefile theFile��  ��    k     |       l     ��   ��    < 6 list of character IDs that make up the path separator      � ! ! l   l i s t   o f   c h a r a c t e r   I D s   t h a t   m a k e   u p   t h e   p a t h   s e p a r a t o r   " # " r      $ % $ J     	 & &  ' ( ' m     ����   (  ) * ) m    ����   *  + , + m    ����   ,  - . - m    ����  .  / 0 / m    ����  0  1 2 1 m    ����   2  3�� 3 m    ����  ��   % o      ���� 0 pathseparator pathSeparator #  4 5 4 l   ��������  ��  ��   5  6 7 6 Q    t 8 9 : 8 k    k ; ;  < = < I   �� > ?
�� .rdwrread****        **** > o    ���� 0 thefile theFile ? �� @ A
�� 
rdfm @ m    ����   A �� B��
�� 
rdfr B m    ����  ��   =  C D C l   ��������  ��  ��   D  E F E l   �� G H��   G E ? keep track of how many bytes we've found in a row matching the    H � I I ~   k e e p   t r a c k   o f   h o w   m a n y   b y t e s   w e ' v e   f o u n d   i n   a   r o w   m a t c h i n g   t h e F  J K J l   �� L M��   L ) # sequence of bytes in pathSeparator    M � N N F   s e q u e n c e   o f   b y t e s   i n   p a t h S e p a r a t o r K  O P O r     Q R Q m    ����   R o      ���� 0 
bytesfound 
bytesFound P  S T S r      U V U m    ����   V o      ���� 0 bytessearched bytesSearched T  W X W l  ! !��������  ��  ��   X  Y Z Y l  ! !�� [ \��   [ ) # Loop through each byte of the data    \ � ] ] F   L o o p   t h r o u g h   e a c h   b y t e   o f   t h e   d a t a Z  ^�� ^ U   ! k _ ` _ k   , f a a  b c b r   , 9 d e d n   , 7 f g f 1   5 7��
�� 
ID   g l  , 5 h���� h I  , 5�� i j
�� .rdwrread****        **** i o   , -���� 0 thefile theFile j �� k l
�� 
rdfm k o   . /���� 0 bytessearched bytesSearched l �� m��
�� 
rdfr m m   0 1���� ��  ��  ��   e o      ���� 0 theid theId c  n o n l  : :��������  ��  ��   o  p q p l  : :�� r s��   r C = Increment bytesFound if we've found another matching byte in    s � t t z   I n c r e m e n t   b y t e s F o u n d   i f   w e ' v e   f o u n d   a n o t h e r   m a t c h i n g   b y t e   i n q  u v u l  : :�� w x��   w = 7 pathSeparator; otherwise, reset the bytesFound counter    x � y y n   p a t h S e p a r a t o r ;   o t h e r w i s e ,   r e s e t   t h e   b y t e s F o u n d   c o u n t e r v  z { z Z   : P | }�� ~ | =  : B  �  o   : ;���� 0 theid theId � n   ; A � � � 4   < A�� �
�� 
cobj � l  = @ ����� � [   = @ � � � o   = >���� 0 
bytesfound 
bytesFound � m   > ?���� ��  ��   � o   ; <���� 0 pathseparator pathSeparator } r   E J � � � [   E H � � � o   E F���� 0 
bytesfound 
bytesFound � m   F G����  � o      ���� 0 
bytesfound 
bytesFound��   ~ r   M P � � � m   M N����   � o      ���� 0 
bytesfound 
bytesFound {  � � � l  Q Q��������  ��  ��   �  � � � l  Q Q�� � ���   � E ? If we found the full sequence of bytes matching pathSeparator,    � � � � ~   I f   w e   f o u n d   t h e   f u l l   s e q u e n c e   o f   b y t e s   m a t c h i n g   p a t h S e p a r a t o r , �  � � � l  Q Q�� � ���   �   we're done!    � � � �    w e ' r e   d o n e ! �  � � � Z  Q ` � ����� � =  Q X � � � o   Q R���� 0 
bytesfound 
bytesFound � I  R W�� ���
�� .corecnte****       **** � o   R S���� 0 pathseparator pathSeparator��   �  S   [ \��  ��   �  � � � l  a a��������  ��  ��   �  ��� � r   a f � � � [   a d � � � o   a b���� 0 bytessearched bytesSearched � m   b c����  � o      ���� 0 bytessearched bytesSearched��   ` l  $ ) ����� � I  $ )�� ���
�� .rdwrgeofcomp       **** � o   $ %���� 0 thefile theFile��  ��  ��  ��   9 R      �� ���
�� .ascrerr ****      � **** � o      ���� 0 msg  ��   : o   s t���� 0 msg   7  � � � l  u u��������  ��  ��   �  � � � l  u u�� � ���   � 6 0 Return the start position of the path separator    � � � � `   R e t u r n   t h e   s t a r t   p o s i t i o n   o f   t h e   p a t h   s e p a r a t o r �  ��� � \   u | � � � o   u v���� 0 bytessearched bytesSearched � I  v {�� ���
�� .corecnte****       **** � o   v w���� 0 pathseparator pathSeparator��  ��     � � � l     ��������  ��  ��   �  � � � l     �� � ���   � C = Read through a file-bookmark's data and return a POSIX path.    � � � � z   R e a d   t h r o u g h   a   f i l e - b o o k m a r k ' s   d a t a   a n d   r e t u r n   a   P O S I X   p a t h . �  � � � i     � � � I      �� ����� "0 getpathfromdata getPathFromData �  ��� � o      ���� 0 thedata theData��  ��   � k     � � �  � � � r      � � � J     	 � �  � � � m     ����   �  � � � m    ����   �  � � � m    ����   �  � � � m    ����  �  � � � m    ����  �  � � � m    ����   �  ��� � m    ����  ��   � o      ���� 0 pathseparator pathSeparator �  � � � l   ��������  ��  ��   �  � � � l   � � ��   � 5 / Create a temporary storage for the binary data    � � � � ^   C r e a t e   a   t e m p o r a r y   s t o r a g e   f o r   t h e   b i n a r y   d a t a �  � � � r     � � � l    ��~�} � I   �| � �
�| .rdwropenshor       file � 4    �{ �
�{ 
psxf � l    ��z�y � m     � � � � � 2 / t m p / g e t _ r e c e n t _ d o c u m e n t s�z  �y   � �x ��w
�x 
perm � m    �v
�v boovtrue�w  �~  �}   � o      �u�u 0 thefile theFile �  � � � I    �t � �
�t .rdwrseofnull���     **** � o    �s�s 0 thefile theFile � �r ��q
�r 
set2 � m    �p�p  �q   �  � � � I  ! *�o � �
�o .rdwrwritnull���     **** � n   ! $ � � � 1   " $�n
�n 
pcnt � o   ! "�m�m 0 thedata theData � �l ��k
�l 
refn � o   % &�j�j 0 thefile theFile�k   �  � � � l  + +�i�h�g�i  �h  �g   �  � � � Q   + � � � � � k   . � � �  � � � l  . .�f � ��f   � I C Start reading the data at the position of the first path separator    � �   �   S t a r t   r e a d i n g   t h e   d a t a   a t   t h e   p o s i t i o n   o f   t h e   f i r s t   p a t h   s e p a r a t o r �  I  . =�e
�e .rdwrread****        **** o   . /�d�d 0 thefile theFile �c
�c 
rdfm I   0 7�b�a�b &0 findpathseparator findPathSeparator 	 o   1 2�`�` 0 thedata theData	 
�_
 o   2 3�^�^ 0 thefile theFile�_  �a   �]�\
�] 
rdfr m   8 9�[�[  �\    l  > >�Z�Y�X�Z  �Y  �X    l  > >�W�W   G A Find the components of the POSIX path and append them to thePath    � �   F i n d   t h e   c o m p o n e n t s   o f   t h e   P O S I X   p a t h   a n d   a p p e n d   t h e m   t o   t h e P a t h  r   > A m   > ? �   o      �V�V 0 thepath thePath �U T   B � k   G �  r   G V n   G T !  1   P T�T
�T 
ID  ! l  G P"�S�R" I  G P�Q#$
�Q .rdwrread****        ****# o   G H�P�P 0 thefile theFile$ �O%�N
�O 
rdfr% m   I L�M�M �N  �S  �R   o      �L�L 0 idlist idList &'& l  W W�K�J�I�K  �J  �I  ' ()( l  W W�H*+�H  * F @ If the last 7 bytes don't identify a path separator, then we've   + �,, �   I f   t h e   l a s t   7   b y t e s   d o n ' t   i d e n t i f y   a   p a t h   s e p a r a t o r ,   t h e n   w e ' v e) -.- l  W W�G/0�G  / . ( read the full file path, and we're done   0 �11 P   r e a d   t h e   f u l l   f i l e   p a t h ,   a n d   w e ' r e   d o n e. 232 Z  W c45�F�E4 l  W [6�D�C6 H   W [77 D   W Z898 o   W X�B�B 0 idlist idList9 o   X Y�A�A 0 pathseparator pathSeparator�D  �C  5  S   ^ _�F  �E  3 :;: l  d d�@�?�>�@  �?  �>  ; <=< l  d d�=>?�=  > L F The first byte tells us how many bytes to read for the path component   ? �@@ �   T h e   f i r s t   b y t e   t e l l s   u s   h o w   m a n y   b y t e s   t o   r e a d   f o r   t h e   p a t h   c o m p o n e n t= ABA r   d lCDC n   d jEFE 4   e j�<G
�< 
cobjG m   h i�;�; F o   d e�:�: 0 idlist idListD o      �9�9 0 	thelength 	theLengthB HIH l  m m�8�7�6�8  �7  �6  I JKJ l  m m�5LM�5  L Q K Read the appropriate number of bytes, and append it to thePath as a string   M �NN �   R e a d   t h e   a p p r o p r i a t e   n u m b e r   o f   b y t e s ,   a n d   a p p e n d   i t   t o   t h e P a t h   a s   a   s t r i n gK OPO r   m �QRQ b   m �STS o   m n�4�4 0 thepath thePathT l  n U�3�2U b   n VWV m   n qXX �YY  /W l  q ~Z�1�0Z I  q ~�/[\
�/ .rdwrread****        ****[ o   q r�.�. 0 thefile theFile\ �-]^
�- 
rdfr] o   s t�,�, 0 	thelength 	theLength^ �+_�*
�+ 
as  _ m   w z�)
�) 
utf8�*  �1  �0  �3  �2  R o      �(�( 0 thepath thePathP `a` l  � ��'�&�%�'  �&  �%  a bcb l  � ��$de�$  d !  Skip past any byte padding   e �ff 6   S k i p   p a s t   a n y   b y t e   p a d d i n gc g�#g I  � ��"hi
�" .rdwrread****        ****h o   � ��!�! 0 thefile theFilei � j�
�  
rdfrj `   � �klk l  � �m��m \   � �non m   � ��� o l  � �p��p `   � �qrq o   � ��� 0 	thelength 	theLengthr m   � ��� �  �  �  �  l m   � ��� �  �#  �U   � R      �s�
� .ascrerr ****      � ****s o      �� 0 msg  �   � o   � ��� 0 msg   � tut l  � �����  �  �  u vwv I  � ��x�
� .rdwrclosnull���     ****x o   � ��� 0 thefile theFile�  w yzy l  � ����
�  �  �
  z {|{ l  � ��	}~�	  } !  Return the full POSIX path   ~ � 6   R e t u r n   t h e   f u l l   P O S I X   p a t h| ��� o   � ��� 0 thepath thePath�   � ��� l     ����  �  �  � ��� l    .���� O     .��� O    -��� k    ,�� ��� r    ��� n   ��� 1    �
� 
valL� n   ��� 4    � �
�  
plii� m    �� ���  B o o k m a r k� n   ��� 2   ��
�� 
plii� n   ��� 4    ���
�� 
plii� m    �� ���  C u s t o m L i s t I t e m s� 4    ���
�� 
plii� m    �� ���  R e c e n t D o c u m e n t s� o      ���� 0 	dataitems 	dataItems� ���� r    ,��� n   *��� 1   ( *��
�� 
valL� n   (��� 4   % (���
�� 
plii� m   & '�� ���  N a m e� n   %��� 2  # %��
�� 
plii� n   #��� 4     #���
�� 
plii� m   ! "�� ���  C u s t o m L i s t I t e m s� 4     ���
�� 
plii� m    �� ���  R e c e n t D o c u m e n t s� o      ���� 0 	itemnames 	itemNames��  � 4    ���
�� 
plif� m    �� ��� b ~ / L i b r a r y / P r e f e r e n c e s / c o m . a p p l e . r e c e n t i t e m s . p l i s t� m     ���                                                                                  sevs  alis    �  Macintosh HD               Љ�JH+     2System Events.app                                               ��50�        ����  	                CoreServices    Љ�J      �5"�       2   &   %  =Macintosh HD:System: Library: CoreServices: System Events.app   $  S y s t e m   E v e n t s . a p p    M a c i n t o s h   H D  -System/Library/CoreServices/System Events.app   / ��  �  �  � ��� l     ��������  ��  ��  � ��� l     ������  � J D Write the name and file path to theOutput, each on a separate line.   � ��� �   W r i t e   t h e   n a m e   a n d   f i l e   p a t h   t o   t h e O u t p u t ,   e a c h   o n   a   s e p a r a t e   l i n e .� ��� l  / 2������ r   / 2��� m   / 0�� ���  � o      ���� 0 	theoutput 	theOutput��  ��  � ��� l  3 6������ r   3 6��� m   3 4���� � o      ���� 0 itemnum itemNum��  ��  � ��� l  7 k������ U   7 k��� k   B f�� ��� r   B `��� b   B ^��� b   B Z��� b   B N��� b   B J��� o   B C���� 0 	theoutput 	theOutput� n   C I��� 4   D I���
�� 
cobj� o   G H���� 0 itemnum itemNum� o   C D���� 0 	itemnames 	itemNames� m   J M�� ���  
� I   N Y������� "0 getpathfromdata getPathFromData� ���� n   O U��� 4   P U���
�� 
cobj� o   S T���� 0 itemnum itemNum� o   O P���� 0 	dataitems 	dataItems��  ��  � m   Z ]�� ���  
� o      ���� 0 	theoutput 	theOutput� ���� r   a f��� [   a d��� o   a b���� 0 itemnum itemNum� m   b c���� � o      ���� 0 itemnum itemNum��  � l  : ?������ I  : ?�����
�� .corecnte****       ****� o   : ;���� 0 	dataitems 	dataItems��  ��  ��  ��  ��  � ��� l     ��������  ��  ��  � ���� l  l m������ o   l m���� 0 	theoutput 	theOutput��  ��  ��       �����������������������  � �������������������������� &0 findpathseparator findPathSeparator�� "0 getpathfromdata getPathFromData
�� .aevtoappnull  �   � ****�� 0 	dataitems 	dataItems�� 0 	itemnames 	itemNames�� 0 	theoutput 	theOutput�� 0 itemnum itemNum��  ��  ��  ��  ��  � �� ���������� &0 findpathseparator findPathSeparator�� ����� �  ������ 0 thedata theData�� 0 thefile theFile��  � ���������������� 0 thedata theData�� 0 thefile theFile�� 0 pathseparator pathSeparator�� 0 
bytesfound 
bytesFound�� 0 bytessearched bytesSearched�� 0 theid theId�� 0 msg  � ������������������������ 
�� 
rdfm
�� 
rdfr�� 
�� .rdwrread****        ****
�� .rdwrgeofcomp       ****
�� 
ID  
�� 
cobj
�� .corecnte****       ****�� 0 msg  ��  �� }jjjkkjj�vE�O a��j�j� OjE�OjE�O I�j kh���k� �,E�O���k/  
�kE�Y jE�O��j   Y hO�kE�[OY��W X 	 
�O��j � �� ����������� "0 getpathfromdata getPathFromData�� �� ��    ���� 0 thedata theData��  � ���������������� 0 thedata theData�� 0 pathseparator pathSeparator�� 0 thefile theFile�� 0 thepath thePath�� 0 idlist idList�� 0 	thelength 	theLength�� 0 msg  � ���� �������������������������������X������~�}�� 
�� 
psxf
�� 
perm
�� .rdwropenshor       file
�� 
set2
�� .rdwrseofnull���     ****
�� 
pcnt
�� 
refn
�� .rdwrwritnull���     ****
�� 
rdfm�� &0 findpathseparator findPathSeparator
�� 
rdfr�� 
�� .rdwrread****        ****�� 
�� 
ID  
�� 
cobj
�� 
as  
�� 
utf8� 0 msg  �~  
�} .rdwrclosnull���     ****�� �jjjkkjj�vE�O)��/�el E�O��jl O��,�l 	O l��*��l+ �j� O�E�O RhZ��a l a ,E�O�� Y hO�a k/E�O�a ��a a � %%E�O�����#�#l [OY��W X  �O�j O�� �|�{�z�y
�| .aevtoappnull  �   � **** k     m � � � � ��x�x  �{  �z     ��w��v����u�t����s��r�q�p�o��n�
�w 
plif
�v 
plii
�u 
valL�t 0 	dataitems 	dataItems�s 0 	itemnames 	itemNames�r 0 	theoutput 	theOutput�q 0 itemnum itemNum
�p .corecnte****       ****
�o 
cobj�n "0 getpathfromdata getPathFromData�y n� +*��/ #*��/��/�-��/�,E�O*��/��/�-��/�,E�UUO�E�OkE�O 3�j kh��a �/%a %*�a �/k+ %a %E�O�kE�[OY��O�� �m	�m 
	 
 

D****book@    0                                   `       System       Library      PreferencePanes      Mouse.prefPane             $   <        %            &            R�           ��          l   |   �   �         A��EN                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     129a5b6c029f76707ee8f6e4af9806b1ae5948d0;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;000000000002d4c1;/system/library/preferencepanes/mouse.prefpane  �   ����            T         �         �       @  �          �         �                   8                  (          d      0   �      ��  �      8****book4    0                                   T       Users        robin   	     Documents        ATL Search.paw             $   8        ӓ          �@	          �@	          �;-         h   x   �   �         A��o�                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     9a4703381e93461fe2af90d202bc4c2c4cc3a009;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;00000000022d3bc6;/users/robin/documents/atl search.paw   �   ����            P         �         �       @  �          �         �                    4                  $          `      0   �      ��  �      0****book,    0                                   L       Library      PreferencePanes      Microsoft Keyboard.prefPane            ,        )            �J          8�          d   t   �         A��                                  	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     5e4107efd7fcd8e2b7b8a776ec619a63a73c12e0;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;00000000001cec38;/library/preferencepanes/microsoft keyboard.prefpane    �   ����            P         �         �       @  �          h         �          �                   �                    H      0   t      ��  |      L****bookH    0                                   h       System       Library      PreferencePanes      Trackpad.prefPane              $   <        %            &            R�           ��          p   �   �   �         A��EH                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     2bdcf46b4e80b7aa472051364e6e08da017b900d;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;000000000002d4e1;/system/library/preferencepanes/trackpad.prefpane   �   ����            X         �         �       @  �          �         �                   <                  ,          h      0   �      ��  �      h****bookd    0                                   �       Users        robin   	     Downloads   &     Improved organization permissions.jpeg             $   8        ӓ          �@	          �@	          5!4         �   �   �   �         A�1?B                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     746c1ca131adf0e0f321ff909038b83793bc934a;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;0000000001342135;/users/robin/downloads/improved organization permissions.jpeg   �   ����            h         �         �       @  �          �                           L         ,         <          x      0   �      ��  �      �****book�    0                                   �       Users        robin   	     Downloads        diveintopython-5.4       diveintopython.pdf             $   8   T        ӓ          �@	          �@	          [/)         \/)         �   �   �   �   �         A�s�`                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     36fa63701458d940a76c56d79b295887fdd405af;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;0000000002292f5c;/users/robin/downloads/diveintopython-5.4/diveintopython.pdf    �   ����            p         �               @  �          �         (         8         l         L         \          �      0   �      ��  �      L****bookH    0                                   h       System       Library      PreferencePanes      Displays.prefPane              $   <        %            &            R�           �;          p   �   �   �         A����                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     dcecf87b4fc6baa4ff9025aa4ff9c92c75bbc52b;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;0000000000023b8f;/system/library/preferencepanes/displays.prefpane   �   ����            X         �         �       @  �          �         �                   <                  ,          h      0   �      ��  �      �****book�    0                                   �       Users        robin        Library 
     Containers       com.apple.mail       Data     Mail Downloads  $     E1152394-8A58-4CE5-97D5-BC7C50ABC529     Mail Attachment (           $   4   H   `   $   l   �   �        ӓ          �@	          A	          �A	          �D	          ��                    �1+          $         $    (     �       (  8  H  X  h  x  �        A��Ni                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /             12575eacd5a111b0b9dd936fdb90f325c7dedadf;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;0000000002241208;/users/robin/library/containers/com.apple.mail/data/library/mail downloads/e1152394-8a58-4ce5-97d5-bc7c50abc529/mail attachment �   ����            �         �        �      @  �         �         �                  <                  ,          h      0   �      ��  �      `****book\    0                                   X       Users        robin        Google Drive	     Documents        2015
     Employment  	     Accenture        R Mitra - PQ (Feb 2014).doc             $   8   L   X   l   �        ӓ          �@	          Jg          ���          ���          �          ;��         !          �   �   �   �       ,  <        A��U�                                               �     	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     d8fdca0a3d4cd672fb95ac7a54a5bd2f86ff52f3;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;0000000002210e1d;/users/robin/google drive/documents/2015/employment/accenture/r mitra - pq (feb 2014).doc   �   ����            �         L        �      @  t         P         �         �                  �         �          0      0   \      �  �      �         �  �      ��  d      `****book\    0                                   |       Users        robin   	     Downloads   $     Karamjeet Kaur - Passport & visa.pdf           $   8        ӓ          �@	          �@	          0!         |   �   �   �         A��f^                                 	  file:///     Macintosh HD       x):         A�#J   $     93B3EFFF-A124-3D8A-9F8C-F80036A4F2C9     �     �                 /         �     ae273866973499fba5fc484f65d2241f622e517a;00000000;00000000;0000000000000020;com.apple.app-sandbox.read-write;00000001;01000004;000000000221301c;/users/robin/downloads/karamjeet kaur - passport & visa.pdf �   ����            d         �         �       @  �          �                           H         (         8          t      0   �      ��  �      � �l�l 
 
  �  M o u s e . p r e f P a n e �    A T L   S e a r c h �!! 6 M i c r o s o f t   K e y b o a r d . p r e f P a n e �"" " T r a c k p a d . p r e f P a n e �## L I m p r o v e d   o r g a n i z a t i o n   p e r m i s s i o n s . j p e g �$$ $ d i v e i n t o p y t h o n . p d f �%% " D i s p l a y s . p r e f P a n e �&&  M a i l   A t t a c h m e n t �'' 6 R   M i t r a   -   P Q   ( F e b   2 0 1 4 ) . d o c �(( H K a r a m j e e t   K a u r   -   P a s s p o r t   &   v i s a . p d f� �))� M o u s e . p r e f P a n e 
 / S y s t e m / L i b r a r y / P r e f e r e n c e P a n e s / M o u s e . p r e f P a n e 
 A T L   S e a r c h 
 / U s e r s / r o b i n / D o c u m e n t s / A T L   S e a r c h . p a w 
 M i c r o s o f t   K e y b o a r d . p r e f P a n e 
 / L i b r a r y / P r e f e r e n c e P a n e s / M i c r o s o f t   K e y b o a r d . p r e f P a n e 
 T r a c k p a d . p r e f P a n e 
 / S y s t e m / L i b r a r y / P r e f e r e n c e P a n e s / T r a c k p a d . p r e f P a n e 
 I m p r o v e d   o r g a n i z a t i o n   p e r m i s s i o n s . j p e g 
 / U s e r s / r o b i n / D o w n l o a d s / I m p r o v e d   o r g a n i z a t i o n   p e r m i s s i o n s . j p e g 
 d i v e i n t o p y t h o n . p d f 
 / U s e r s / r o b i n / D o w n l o a d s / d i v e i n t o p y t h o n - 5 . 4 / d i v e i n t o p y t h o n . p d f 
 D i s p l a y s . p r e f P a n e 
 / S y s t e m / L i b r a r y / P r e f e r e n c e P a n e s / D i s p l a y s . p r e f P a n e 
 M a i l   A t t a c h m e n t 
 / U s e r s / r o b i n / L i b r a r y / C o n t a i n e r s / c o m . a p p l e . m a i l / D a t a / M a i l   D o w n l o a d s / E 1 1 5 2 3 9 4 - 8 A 5 8 - 4 C E 5 - 9 7 D 5 - B C 7 C 5 0 A B C 5 2 9 / M a i l   A t t a c h m e n t 
 R   M i t r a   -   P Q   ( F e b   2 0 1 4 ) . d o c 
 / U s e r s / r o b i n / G o o g l e   D r i v e / D o c u m e n t s / 2 0 1 5 / E m p l o y m e n t / A c c e n t u r e / R   M i t r a   -   P Q   ( F e b   2 0 1 4 ) . d o c 
 K a r a m j e e t   K a u r   -   P a s s p o r t   &   v i s a . p d f 
 / U s e r s / r o b i n / D o w n l o a d s / K a r a m j e e t   K a u r   -   P a s s p o r t   &   v i s a . p d f 
�� ��  ��  ��  ��  ��  ascr  ��ޭ