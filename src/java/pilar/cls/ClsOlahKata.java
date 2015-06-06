/* Nama berkas: ClsOlahKata.java
 * Fungsi: menangani pengolahan kata (string)
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Rabu, 04 Maret 2015, 22.56 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;
/**
 *
 * @author ariana
 */

public class ClsOlahKata {
    /* fHapusSpasi: menghapus spasi sebuah kalimat, berguna pada kode. */
    public String fHapusSpasi(String vFKata){
        String vKeluaranAkhir ="";
        StringBuilder vSb = new StringBuilder();
        String[] vArrKata = vFKata.split("");
        
        for(String vKata : vArrKata){
            vSb.append(vKata.trim());
        }
        
        /* parsing tahap 2 */
        vKeluaranAkhir = vSb.toString().replaceAll("\\s+", "");
        /* nilai keluaran akhir */
        return vKeluaranAkhir;
    }
    
    /* fSatuSpasi: format kalimat menghilangkan spasi berlebih,
        berguna pada judul, nama negara, dan nama standar lainnya.
    */
    public String fSatuSpasi(String vFKata){
        String vKeluaranAkhir ="";
        
        try{
            StringBuilder vSb = new StringBuilder();

            vFKata = vFKata.replace(".", " . ");
            vFKata = vFKata.replace(",", " , ");
            vFKata = vFKata.replace("!", " ! ");
            vFKata = vFKata.replace("\\?", " ? ").trim();

            String[] vArrKata = vFKata.split(" ");

            boolean vKataPertama = true;
            for(String vKata : vArrKata){
                vKata = vKata.trim();

                if(!vKata.equals("")){
                    if(vKataPertama){
                        vSb.append(vKata.trim());
                        vKataPertama = false;
                    }else{

                        if(vKata.equals(".") || 
                            vKata.equals(",") ||
                            vKata.equals("!") ||
                            vKata.equals("?")){
                            vSb.append("");
                        }else{
                            vSb.append(" ");
                        }

                        vSb.append(vKata.trim());
                    }
                }
            }

            /* parsing tahap 2 */
            vKeluaranAkhir = vSb.toString().replaceAll("\\s+", " ");
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsOlahKata.java";
                String vNamaMetode = "fSatuSpasi";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        /* nilai keluaran akhir */
        return vKeluaranAkhir;
    }
}
