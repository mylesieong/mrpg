package com.myles.fun;

import java.util.List;
import java.util.ArrayList;

/**
 *
 */
public class RPG{

    public final static int FILE_INQUIRY = 0;
    public final static int FILE_UPDATE_N_ADD = 1;
    public final static int FILE_UPDATE_ONLY = 2;

    private List<FileDefinition> _fds;
    private List<ControlDefinition> _cds;

    public RPG(){
        _fds = new ArrayList<FileDefinition>();
        _cds = new ArrayList<ControlDefinition>();
    }

    public void setFile(String file, int type){
        _fds.add(new FileDefinition(file, type));
    }

    @Override 
    public String toString(){
        StringBuilder sb = new StringBuilder();
        for (FileDefinition fd: _fds){
            sb.append(fd);
            sb.append("\n");
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
    }

}
