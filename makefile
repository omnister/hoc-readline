YFLAGS = -d
BIN = /usr/local/bin/
MAN = /usr/local/man/man1/
SRCS = hoc.y code.c init.c math.c symbol.c
OBJS = hoc.o code.o init.o math.o symbol.o 
DEMOS =  demo.ack demo.depth demo.fib demo.ohmcalc
HEADERS = hoc.h y.tab.h
EXTRAS = hoc.1 README TODO hocold.y hocreadline.y
CCFLAGS = -g -Wall

hoc:	$(OBJS)
	cc $(CCFLAGS) $(OBJS) -lm -o hoc -lreadline -g -lncurses

hoc.o code.o init.o symbol.o: hoc.h

code.o init.o symbol.o: x.tab.h

.c.o:
	cc $(CCFLAGS) -c $*.c   

x.tab.h: y.tab.h
	cmp -s x.tab.h y.tab.h || cp y.tab.h x.tab.h

pr:	hoc.y hoc.h code.c init.c math.c symbol.c
	@cpr $? | jet2
	@touch pr

clean:
	rm -f $(OBJS) y.output
install: hoc
	cp hoc $(BIN)/hoc
	cp hoc.1 $(MAN)/hoc.1
	#cp * /usr/local/src/cmd/hoc

tar:
	tar cvf - README makefile $(SRCS) $(DEMOS) $(HEADERS) $(EXTRAS) > hoc.tar
