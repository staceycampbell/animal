$! I was poking around a tape containing some of my
$! old university stuff and found this.
$! 
$! It's a VAX/VMS Version 3.? DCL implementation of the
$! old game 'Animal'.  It should work for later versions
$! of VMS.  It supports saving and reading the question
$! database.  It is probably one of the most twisted
$! implementations of this game.  I was quite proud of
$! it when I wrote it.  Use at your own risk!
$! 
$!Animal meets DCL
$!Stacey Campbell
$!August holidays, 1985.
$!La Trobe University
$!usage:   $ @animal
$ say="write sys$output"
$ ask="inquire/nopunctuation"
$ say "Lets have fun with trees and animals,"
$ say "see if I can guess what you are thinking!"
$ say ""
$ i=1
$ cu=1
$ nil=9999
$ ask tmps "Do you have the animal database? "
$ tmps=f$extract(0,1,tmps)
$ if tmps.eqs."Y" then $ goto get_database
$initial:
$ q'i:=Does it swim
$ cu=cu+1
$ y'i=cu
$ q'cu:=Is it a cod fish
$ cu=cu+1
$ n'i=cu
$ q'cu:=Is it a cow
$ tmp=y'i
$ y'tmp=nil
$ n'tmp=nil
$ tmp=n'i
$ y'tmp=nil
$ n'tmp=nil
$l240:
$ ask an "Are you thinking of an animal? "
$ an=f$extract(0,1,an)
$ if an.eqs."Y" then $ goto l3000
$ ask tmps "Do you want your database saved? "
$ tmps=f$extract(0,1,tmps)
$ if tmps.eqs."Y" then $ goto put_database
$ say "Goodbye."
$ exit
$l3000:
$ i=1
$l3010:
$ if i.ne.nil then $ goto l4000
$ if re.nes."Y" then $ goto l5000
$ say "I guessed correctly!"
$ goto l240
$l4000:
$ tmps=q'i
$ say "''tmps'?"
$ ask re ""
$ io=i
$ re=f$extract(0,1,re)
$ tmpy=y'i
$ tmpn=n'i
$ if re.eqs."Y" then $ i=tmpy
$ if re.nes."Y" then $ i=tmpn
$ goto l3010
$l5000:
$ i=io
$ ask g "What are you thinking of? "
$ tmps=q'i
$ tmps=f$extract(8,f$length(tmps)-8,tmps)
$ say "What is a question to distinguish a ",g," from a ",tmps
$ ask b ""
$ say "For a ''g' the answer would be? "
$ ask t ""
$ t=f$extract(0,1,t)
$ if t.eqs."Y" then $ goto l6000
$ goto l7000
$l6000:
$ cu=cu+1
$ y'i=cu
$ q'cu:=Is it a 'g
$ y'cu=nil
$ n'cu=nil
$ cu=cu+1
$ n'i=cu
$ tmps=q'i
$ q'cu=tmps
$ y'cu=nil
$ n'cu=nil
$ q'i=b
$ goto l240
$l7000:
$ cu=cu+1
$ n'i=cu
$ q'cu:=Is it a 'g
$ n'cu=nil
$ y'cu=nil
$ cu=cu+1
$ y'i=cu
$ tmps=q'i
$ q'cu=tmps
$ n'cu=nil
$ y'cu=nil
$ q'i=b
$ goto l240
$get_database:
$ if f$search("ANIMAL.DATABASE").eqs."" then $ goto nofile
$ open/read infile animal.database
$ read infile cu
$ j=1
$readloop:
$ read/end_of_file=readend_of_loop infile q'j
$ read infile y'j
$ read infile n'j
$ j=j+1
$ goto readloop
$readend_of_loop:
$ close infile
$ goto l240
$nofile:
$ ask tmps "I cannot find it, do you still want to play? "
$ tmps=f$extract(0,1,tmps)
$ if tmps.eqs."Y" then $ goto initial
$ say "Goodbye."
$ exit
$put_database:
$ open/write/error=cannot_open outfile animal.database
$ write outfile cu
$ j=1
$ saved_message=f$environment("MESSAGE")
$ set message/nofacility/noidentification/noseverity/notext
$ on warning then $ goto writeend_of_loop
$writeloop:
$ tmpy=y'j
$ write outfile q'j
$ write outfile tmpy
$ write outfile n'j
$ j=j+1
$ goto writeloop
$writeend_of_loop:
$ set message'saved_message'
$ close outfile
$ say "Goodbye."
$ exit
$cannot_open:
$ say "Sorry, I cannot open the file."
$ say "Goodbye."
$ exit
