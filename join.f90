PROGRAM join

IMPLICIT NONE

      INTEGER :: i, n_temp, nl, l
      REAL :: q_neg, q_pos
      CHARACTER(LEN=255) :: path, dir, n_files, files

      l = 0
      nl = 0

      CALL GETCWD (path)
      CALL GET_COMMAND_ARGUMENT (1, dir)
      CALL CHDIR (TRIM(path)//"/"//dir)
      CALL EXECUTE_COMMAND_LINE ("ls -v1 ele[1-9]*.dat > tmp_file_1.txt")
      CALL EXECUTE_COMMAND_LINE ("wc tmp_file_1.txt | awk '{print $1}' > tmp_file_2.txt")
      OPEN (10, FILE="tmp_file_2.txt")
          READ (10, "(A)") n_files
      CLOSE (10)
      CALL EXECUTE_COMMAND_LINE ("rm tmp_file_2.txt")
      WRITE (*,*) "Foram encontrados "//TRIM(n_files)//" arquivos *.dat"

      OPEN (10, FILE="tmp_file_1.txt")
      OPEN (20, FILE="ele-join.dat", STATUS="UNKNOWN")
          DO
            READ (10, "(A)", END=10) files
            OPEN (30, FILE=files, STATUS="OLD")
                DO
                  READ (30, *, END=20) n_temp, q_neg, q_pos
                  WRITE (20, 1000) n_temp + nl, q_neg, q_pos
                  l = l + 1
                ENDDO
20              CONTINUE
            CLOSE (30)
                nl = nl + l
                WRITE (*, "(A,I0,A)") "O arquivo "//TRIM(ADJUSTL(files))//" contém ", l," linhas"
                l = 0
          ENDDO
10        CONTINUE
          WRITE (*, "(A,I0)") "O total de linhas no arquivo ele-join.dat é de ", nl
      CLOSE (10)
      CLOSE (20)

      CALL EXECUTE_COMMAND_LINE ("rm tmp_file_1.txt")

1000  FORMAT(I0,X,F7.3,X,F6.3)

END PROGRAM
