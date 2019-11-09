p1: p1.awk exemplo_1.txt
	clear
	gawk -f p1.awk < exemplo_1.txt > output_1.html

p2: p2.awk exemplo_2.txt
	clear
	gawk -f p2.awk < exemplo_2.txt > output_2.html

p2: p3.awk exemplo_2.txt
	clear
	gawk -f p3.awk < exemplo_2.txt > output_3.txt


clean:
	rm -f *.html