a.out: main.o libass2_20CS10005.a
	cc main.o -L. -lass2_20CS10005

main.o: main.c myl.h
	cc -c main.c

libass2_20CS10005.a: ass2_20CS10005.o
	ar -rcs libass2_20CS10005.a ass2_20CS10005.o

ass2_20CS10005.o: ass2_20CS10005.c myl.h
	cc -c ass2_20CS10005.c

clean:
	rm a.out main.o libass2_20CS10005.a ass2_20CS10005.o