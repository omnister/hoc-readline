func ack() {
	if ($1 == 0) {
	    return $2+1;
	}
	if ($2 == 0) {
	    return ack($1-1, 1);
	}
	return (ack($1-1, ack($1, $2-1)));
}

i=0;
while (i<4) {
	j=0;
	while (j<4) {
		print "ack(",i,",",j,") \t= ",ack(i,j),"\n";
		j = j+1;
	}
	i = i+1;
}

