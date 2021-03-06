CLEAR ALL
CLOSE ALL
CLEAR 

SELECT 0
USE subject_description ORDER name
zap
SELECT 0
USE subject
zap

&& find out what kind of subjects are being presented to us
&& for each:
&& determine subject type
&& if it already exists, find it and get the subject id
&& if it doesn't exist, create it and get the subject id

tbl_usr_subjects = GETFILE()
?tbl_usr_subjects
IF FILE("&tbl_usr_subjects.")
	SELECT 0
	USE "&tbl_usr_subjects." ALIAS subjects SHARED
ELSE
	return
endif

&& for each of the subjects presented to us
SCAN
	subj_type = subjects.subj_name
	m.subject_id = subject_id(subj_type)
	&& put them into our subject table
	IF m.subject_id = -1
		SELECT subject
		APPEND BLANK
		SCATTER MEMVAR MEMO
		m.id = RECNO()
		m.class = .null.
		m.start = DATETIME()
		m.end = .null.
		GATHER MEMVAR MEMO
		SELECT subject_description
		APPEND BLANK
		m.subject_id = m.id
		m.name = subjects.subj_name
		m.description = "blah blah blah"
		GATHER MEMVAR MEMO
		SELECT subjects
	ENDIF

	&& gather field information about the current subject
	SELECT 0
	tbl_cur_subject = GETFILE()
	?tbl_cur_subject
	IF FILE("&tbl_cur_subject.")
		SELECT 0
		USE "&tbl_cur_subject." ALIAS cur_subj SHARED
		COPY STRUCTURE EXTENDED TO metadata 
		USE metadata
	ELSE
		return
	endif
	brow
	&& insert field/attribute information into our tables
	SCAN
	endscan	
	SELECT subjects
		
ENDSCAN


RETURN

FUNCTION subject_id(txt_subject_name)
	wrk_area = ALIAS()
	cur_recno = RECNO()

	SELECT subject_description
	SEEK txt_subject_name
	IF FOUND()
		rtn_subject_id = subject_description.subject_id
	ELSE && you're at EOF or BOF
		rtn_subject_id = -1
	ENDIF
	SELECT &wrk_area.
	GOTO cur_recno

	RETURN rtn_subject_id
ENDFUNC

FUNCTION phils_func()
	UPDATE subject id = RECNO() WHERE id = 0
	RETURN .t.
ENDFUNC
