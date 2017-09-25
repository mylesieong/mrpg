package com.myles.fun;

import java.util.List;
import java.util.ArrayList;

/**
 *
 */
public class RPG{

    /**
     * File related options
     */
    public final static int FILE_INQUIRY = 0;
    public final static int FILE_UPDATE_N_ADD = 1;
    public final static int FILE_UPDATE_ONLY = 2;

    /**
     * Control related options
     */
    public final static int CONTROL_DELETE = 0;

    private List<FileDefinition> _fds;
    private List<ControlDefinition> _cds;

    public RPG(){
        _fds = new ArrayList<FileDefinition>();
        _cds = new ArrayList<ControlDefinition>();
    }

    public void addFile(String file, int type){
        //TODO check if file added already, if yes, update
        _fds.add(new FileDefinition(file, type));
    }

    public void addControl(String file, int type){
        //TODO is it possible to get update?
        _cds.add(new ControlDefinition(file, type));
    }

    @Override 
    public String toString(){
        StringBuilder sb = new StringBuilder();

        for (FileDefinition fd: _fds){
            sb.append(fd);
            sb.append("\n");
        }

        for (ControlDefinition cd: _cds){
            for (String s: cd.toStrings()){
                sb.append(s);
                sb.append("\n");
            }
        }

        return sb.toString();
    }

    /**
     *
     */
    class FileDefinition{

        private final static String FD_FORMAT = "F%s %sF %s E K DISK";

        private String _file;
        private int _type;

        public FileDefinition(String file, int type){
            _file = file;
            _type = type;
        }

        @Override
        public String toString(){
            String p1;
            String p2;
            if (_type == FILE_UPDATE_ONLY){
                p1 = "U";
                p2 = " "; 
            }else if (_type == FILE_UPDATE_N_ADD){
                p1 = "U";
                p2 = "A"; 
            }else{
                p1 = "I";
                p2 = " "; 
            }
            return String.format(FD_FORMAT, _file, p1, p2);
        }

    }

    /**
     *
     */
    class ControlDefinition{

        private final static String CD_READ_FORMAT = "C READ %s";
        private final static String CD_DOW_PART_A_FORMAT = "C DOW NOT %EOF";
        private final static String CD_DOW_PART_B_FORMAT = "(%s)";
        private final static String CD_DELETE_FORMAT = "C DELETE %s";
        private final static String CD_WRITE_FORMAT = "C WRITE %s";
        private final static String CD_UPDATE_FORMAT = "C UPDATE %s";
        private final static String CD_EVAL_FORMAT = "C EVAL %s = %s";
        private final static String CD_EVAL_LAMBDA_FORMAT = "C EVAL %s";
        private final static String CD_ENDDO_FORMAT = "C ENDDO";

        private String _file;
        private int _type;

        public ControlDefinition(String file, int type){
            _file = file;
            _type = type;
        }

        public List<String> toStrings(){
            List<String> result = new ArrayList<String>();

            if (_type == RPG.CONTROL_DELETE){
                result.add(String.format(CD_READ_FORMAT, _file));
                result.add(CD_DOW_PART_A_FORMAT
                        + String.format(CD_DOW_PART_B_FORMAT, _file));
                result.add(String.format(CD_DELETE_FORMAT, _file));
                result.add(String.format(CD_READ_FORMAT, _file));
                result.add(String.format(CD_ENDDO_FORMAT, _file));
            }

            return result;
        }
        
    }

}
