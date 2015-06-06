/* Nama berkas: ClsSrvAdpubCaptcha.java
 * Fungsi: menangani captcha
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Minggu, 01 Maret 2015, 21.56 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.servlet.adpub;

import pilar.cls.ClsKonf;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

import java.util.Random;
import javax.imageio.ImageIO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.security.SecureRandom;

public class ClsSrvAdpubCaptcha extends HttpServlet {

    protected void processRequest(HttpServletRequest request, 
                                HttpServletResponse response) 
                 throws ServletException, IOException {

        int width = 165;
        int height = 50;      

        /* acak latar */
        String[] s = {"01", "02", "03", "04"};
	Random ran = new Random();
	String vLatarTerpilih = s[ran.nextInt(s.length)];  
	
	/* operasi berkas */
	//String pathToWeb = getServletContext().getRealPath(File.separator);
	File f = new File(ClsKonf.vKonfDirCaptcha + 
		File.separator + "latar" + 
		File.separator + "latar" + vLatarTerpilih + ".png");
	BufferedImage bufferedImage = ImageIO.read(f);
	
        
    /*BufferedImage bufferedImage = new BufferedImage(width, height, 
                  BufferedImage.TYPE_INT_RGB);*/

    Graphics2D g2d = bufferedImage.createGraphics();

	/* font */	
	try{		
            /* acak font */
            String[] vArrFont = {"1", "2", "3", "4"};
            Random ranf = new Random();
            String vFontTerpilih = vArrFont[ranf.nextInt(vArrFont.length)];
            String vBerkasFont;
            vBerkasFont = ClsKonf.vKonfDirCaptcha + 
            File.separator + "fonts" +
            File.separator + vFontTerpilih + ".TTF";

            InputStream vIsFont = new FileInputStream(vBerkasFont);
            Font vFont = Font.createFont(Font.TRUETYPE_FONT, vIsFont);

            vFont = vFont.deriveFont(24f);
            g2d.setFont(vFont);
		
	} catch (FontFormatException | IOException e) {
    } 
	
    RenderingHints vRh = new RenderingHints(
           RenderingHints.KEY_ANTIALIASING,
           RenderingHints.VALUE_ANTIALIAS_ON);

    vRh.put(RenderingHints.KEY_RENDERING, 
           RenderingHints.VALUE_RENDER_QUALITY);

    g2d.setRenderingHints(vRh);    
	/* warna huruf */
    g2d.setColor(new Color(21, 48, 73));    
    
    String vCaptcha = ClsSrvAdpubCaptcha.fBuatKodeAcak();
    request.getSession().setAttribute("sesCaptcha", vCaptcha );
    
    /* string -> char[] */
    char[] vArrCaptcha = vCaptcha.toCharArray();   

    Random vAcak = new Random();    
    int x = 0; 
    int y = 0;

    for (int i=0; i<vArrCaptcha.length; i++) {
        x += 15 + (Math.abs(vAcak.nextInt()) % 15);
        y = 20 + Math.abs(vAcak.nextInt()) % 20;
        g2d.drawChars(vArrCaptcha, i, 1, x, y);
    }

    g2d.dispose();
    
    response.setContentType("image/png");
      try (OutputStream os = response.getOutputStream()) {
          ImageIO.write(bufferedImage, "png", os);
      }
  } 

  @Override
  protected void doGet(HttpServletRequest request, 
                       HttpServletResponse response)
                           throws ServletException, IOException {
      processRequest(request, response);
  } 

  @Override
  protected void doPost(HttpServletRequest request, 
                        HttpServletResponse response)
                            throws ServletException, IOException {
      processRequest(request, response);
  }  
  
  private static final Random RANDOM = new SecureRandom();
  /** Length of password. @see #generateRandomPassword() */
  public static final int PASSWORD_LENGTH = 5;
  /**
   * Generate a random String suitable for use as a temporary password.
   *
   * @return String suitable for use as a temporary password
   * @since 2.4
   */
  public static String fBuatKodeAcak()
  {      
      String vAbjadNum = "abcdefghjkmnpqrstuvwxyzABCDEFGHJKMNPQRSTUVWXYZ23456789";

      String vNilaiKeluaran = "";
      for (int i=0; i<PASSWORD_LENGTH; i++)
      {
          int index = (int)(RANDOM.nextDouble()*vAbjadNum.length());
          vNilaiKeluaran += vAbjadNum.substring(index, index+1);
      }
      return vNilaiKeluaran;
  }
}
