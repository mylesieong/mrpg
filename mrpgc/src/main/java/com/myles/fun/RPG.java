package com.myles.fun;

import java.util.List;
import java.util.ArrayList;

/**
 *
 */
public class RPG{


    private List<FileDefinition> _fds;
    private List<ControlDefinition> _cds;

    public RPG(){
        _fds = new ArrayList<FileDefinition>();
        _cds = new ArrayList<ControlDefinition>();
    }

    public void addFile(FileDefinition fd){
        _fds.add(fd);
    }

    public void addControl(ControlDefinition cd){
        _cds.add(cd);
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
    public static class FileDefinition{

        /**
         * File related options
         */
        public final static int FILE_INQUIRY = 0;
        public final static int FILE_UPDATE_N_ADD = 1;
        public final static int FILE_UPDATE_ONLY = 2;

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
    public static class ControlDefinition{
        /**
         * Control related options
         */
        public final static int CONTROL_LOOP_FILE = 0;
        public final static int CONTROL_IF = 1;
        public final static int CONTROL_UPDATE = 2;
        public final static int CONTROL_WRITE = 3;
        public final static int CONTROL_DELETE = 4;
        public final static int CONTROL_EVAL = 5;

        private final static String CD_READ_FORMAT = "C READ %s";
        private final static String CD_DOW_PART_A_FORMAT = "C DOW NOT %EOF";
        private final static String CD_DOW_PART_B_FORMAT = "(%s)";
        private final static String CD_DELETE_FORMAT = "C DELETE %s";
        private final static String CD_WRITE_FORMAT = "C WRITE %s";
        private final static String CD_UPDATE_FORMAT = "C UPDATE %s";
        private final static String CD_EVAL_FORMAT = "C EVAL %s";
        private final static String CD_ENDDO_FORMAT = "C ENDDO";
        private final static String CD_IF_FORMAT = "C IF %s";
        private final static String CD_ENDIF_FORMAT = "C ENDIF";

        private String _parameter;
        private int _type;
        private List<ControlDefinition> _embeds;

        public ControlDefinition(){
            _embeds = new ArrayList<ControlDefinition>();
        }

        public void setType(int type){
            _type = type;
        }

        public void setParameter(String p){
            _parameter = p;
        }

        public void addEmbed(ControlDefinition cd){
            _embeds.add(cd);
        }

        public List<String> toStrings(){
            List<String> result = new ArrayList<String>();

            switch (_type){
                case CONTROL_LOOP_FILE:
                    result.add(String.format(CD_READ_FORMAT, _parameter));
                    result.add(CD_DOW_PART_A_FORMAT
                        + String.format(CD_DOW_PART_B_FORMAT, _parameter));
                    for (ControlDefinition cd: _embeds){
                        for (String s: cd.toStrings()){
                            result.add(s);
                        }
                    } 
                    result.add(String.format(CD_READ_FORMAT, _parameter));
                    result.add(String.format(CD_ENDDO_FORMAT, _parameter));
                    break;

                case CONTROL_DELETE:
                    result.add(String.format(CD_DELETE_FORMAT, _parameter));
                    break;

                case CONTROL_EVAL:
                    result.add(String.format(CD_EVAL_FORMAT, _parameter));
                    break;

                case CONTROL_UPDATE:
                    result.add(String.format(CD_UPDATE_FORMAT, _parameter));
                    break;

                case CONTROL_WRITE:
                    result.add(String.format(CD_WRITE_FORMAT, _parameter));
                    break;

                case CONTROL_IF:
                    result.add(String.format(CD_IF_FORMAT, _parameter));
                    for (ControlDefinition cd: _embeds){
                        for (String s: cd.toStrings()){
                            result.add(s);
                        }
                    } 
                    result.add(String.format(CD_ENDIF_FORMAT));
                    break;

                default:
                    break;
            } 

            return result;
        }
        
    }

}
