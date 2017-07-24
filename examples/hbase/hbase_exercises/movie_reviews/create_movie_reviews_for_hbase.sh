#!/bin/sh

#
#  This script structures the movie review data to be imported into HBASE
#
#  There are 12500 negative reviews. Each negative review has a neg_review_id 
#  which ranges from 0 to 12499 
#
#  There are 12500 positive reviews. Each positive review has a pos_review_id
#  which ranges from 0 to 12499 
#
#  Each row of data that is produced by this script has the following format
#     rowkey \t complete text of the movie review
#
#  The rowkey is a compound key made up of three fixed width fields:
#     1) The movie id (movie_id) which is of the 'tt1234567'. That is, the letters 'tt' 
#        followed by 7 digits. Movie ids are embedded in URLs contained in 
#        the following two files: 'urls_neg.txt' and 'urls_pos.txt'. The URLs
#        are ordered by the review id starting with review id 0.
#     2) The rating of the movie given by this review in a 3 character wide field 
#        padded by '-'. The rating is a component of the file name containing the
#        review text. Review file names have the
#        following structure: 'review_id_rating.txt'. That is, the rating is 
#        preceeded by an '_' and followd by '.txt'.
#     3) The review id in a 6 character wide field padded by '-'. The review id 
#        is a component of the file name containing the review text.
#
INDIR=/home/student/roihadoop/pig_exercises/aclImdb/train
OUTDIR=/home/student/roihadoop/hbase_exercises/movie_reviews
RATING_PADDING='---'
ID_PADDING='------'

date1=$(date +"%s")

#negative reviews
NEG_REVIEW_FILE=neg_movie_reviews_for_hbase.txt
NEG_URL_FILE=${INDIR}/urls_neg.txt
neg_review_id=0
exec<$NEG_URL_FILE
while read neg_url
do
	#Extract the movie id
	movie_id=`echo $neg_url | awk -F/ -vORS= '{print $5}'`

	#Extract the movie rating from the review text file name
	#First obtain the path of the review .txt file for the current neg_review_id
	review_file_path=`ls ${INDIR}/neg/${neg_review_id}_*.txt`

        # Remove the .txt extension from the path. '%.txt'  is a regular expression for 
        # matching the shortest substring from the end. 
	review_file_path_no_extension=`echo ${review_file_path%.txt}`

        # Remove the leading components of the path up to an including the last '_'. 
        # '##*_' is a regular expression that matches the longest substring from the 
        # beginning up to the last '_'.
	rating=`echo ${review_file_path_no_extension##*_}`

        # print the row key 
	printf "%s%s%s%s%s\t" ${movie_id} ${RATING_PADDING:${#rating}} $rating ${ID_PADDING:${#neg_review_id}} ${neg_review_id} >> ${OUTDIR}/${NEG_REVIEW_FILE}
        # append the review text
	cat ${INDIR}/neg/${neg_review_id}_*.txt >> ${OUTDIR}/${NEG_REVIEW_FILE}
        # append a new line '\n' to the end of the row
	echo "" >> ${OUTDIR}/${NEG_REVIEW_FILE}
        #increment the review id
	neg_review_id=`expr $neg_review_id + 1`;
done

date2=$(date +"%s")
diff=$(($date2-$date1))
echo "finished processing negative reviews"
echo "$(($diff / 60)) minutes and $(($diff % 60)) seconds elapsed."

#positive reviews
POS_REVIEW_FILE=pos_movie_reviews_for_hbase.txt
POS_URL_FILE=${INDIR}/urls_pos.txt
pos_review_id=0
exec<$POS_URL_FILE
while read pos_url
do
	#Extract the movie id
	movie_id=`echo $pos_url | awk -F/ -vORS= '{print $5}'`

	#Extract the movie rating from the review text file name
	#First obtain the path of the review .txt file for the current pos_review_id
	review_file_path=`ls ${INDIR}/pos/${pos_review_id}_*.txt`

        # Remove the .txt extension from the path. '%.txt'  is a regular expression for 
        # matching the shortest substring from the end. 
	review_file_path_no_extension=`echo ${review_file_path%.txt}`

        # Remove the leading components of the path up to an including the last '_'. 
        # '##*_' is a regular expression that matches the longest substring from the 
        # beginning up to the last '_'.
	rating=`echo ${review_file_path_no_extension##*_}`

        # print the row key 
	printf "%s%s%s%s%s\t" ${movie_id} ${RATING_PADDING:${#rating}} $rating ${ID_PADDING:${#pos_review_id}} ${pos_review_id} >> ${OUTDIR}/${POS_REVIEW_FILE}
        # append the review text
	cat ${INDIR}/pos/${pos_review_id}_*.txt >> ${OUTDIR}/${POS_REVIEW_FILE}
        # append a new line '\n' to the end of the row
	echo "" >> ${OUTDIR}/${POS_REVIEW_FILE}
        #increment the review id
	pos_review_id=`expr $pos_review_id + 1`;
done

date3=$(date +"%s")
diff2=$(($date3-$date2))
echo "finished processing positive reviews"
echo "$(($diff2 / 60)) minutes and $(($diff2 % 60)) seconds elapsed."
diff3=$(($date3-$date1))
echo "$(($diff3 / 60)) minutes and $(($diff3 % 60)) overall seconds elapsed."
