

filename ls pipe "ls -l /source/reports/passport/pcl/AUG1902/Detail/ | awk '{print $9, $5}'";

	data grab_files(drop=lsoutput);
	infile ls truncover end=lstobs;
	format lsoutput $256.;
	input lsoutput $256.;
	filename=lsoutput;
	run;

	
proc sql;
	create table result as
	select filename as file_with_size, 
			scan(filename,1," ") as Filenames, 
			ceil(input(scan(filename,2," "),8.)/1024) format=8. as KB_Size 
	from grab_files
	where filename like '%_hdr_%'
	order by Filenames
	;
quit;