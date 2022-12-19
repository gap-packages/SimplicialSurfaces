
Exec(" pdflatex //home/reymond/.gap/pkg/simplicial-surfaces/tutorial/tutorial.tex");
Exec("mv tutorial.pdf tutorial");
Exec("rm *.log *.aux *.out *.pnr *.idx");
Exec("mv tutorial tutorial.pdf");
QUIT;
