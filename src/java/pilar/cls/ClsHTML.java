/* Nama berkas: ClsHTML.java
 * Fungsi: menangani pemrosesan berkas HTML
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Selasa, 03 Maret 2015, 19.10 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

public class ClsHTML {
    
    private String vPrvClassCSS;
    
    /* append sb */
    public String fForm(
            String vFMethod, 
            String vFURLAction, 
            String[] vFArrLabel, 
            String[] vFArrName, 
            String[] vFArrTipe,
            String[] vFArrNilai,
            String vFTombol,
            String vFIdCSS,
            String vFClassCSS){
       
        /* nilai keluaran awal */
        this.vPrvClassCSS = vFClassCSS;
        StringBuilder vSb = new StringBuilder();
        
        try{
            String vMethod, vLabelKolom, vTipeKolom, vNamaKolom, vNilaiKolom;
            vMethod = vFMethod.equals("POST") ? "POST" : "GET"; /* default: POST */            
                        
            /* form */
            vSb.append("<form id=\"");
            vSb.append(vFIdCSS);
            vSb.append("\" class=\"");
            vSb.append(vFClassCSS);
            vSb.append("\" method=\"");
            vSb.append(vMethod);
            vSb.append("\" action=\"");
            vSb.append(vFURLAction);
            vSb.append("\">\r\n");
            vSb.append("<table>");
            
            /* variabel iterasi */
            int i=0, j=0, k=0;
            
            String[] vArrNmKolom, vArrNlKolom, vArrSubNlKolom, vArrOptionKolom;
                        
            /* iterasi untuk masing-masing name="" */
            for(String vName : vFArrName){
                /* tipe kolom input */
                vLabelKolom = vFArrLabel[i].trim(); /* label kolom */
                vTipeKolom = vFArrTipe[i].trim(); /* type kolom */
                vNamaKolom = vFArrName[i].trim(); /* name kolom */
                vNilaiKolom = vFArrNilai[i].trim(); /* nilai kolom: a&A#b&B */
                
                /* sub kolom */
                vArrNmKolom = vNamaKolom.split("#");
                vArrNlKolom = vNilaiKolom.split("#"); /* array nilai kolom --> a&A dan b&B --> 2 data */
                
                /* jumlah kolom */
                int jKol = vArrNmKolom.length; /* bila satu baris kolom lebih dari 1*/
                               
                /* pilih kasus
                   (1) tipe a --> text, password, hidden
                */
                switch(vTipeKolom.substring(0, 1)){
                    case "@":
                        vTipeKolom = vTipeKolom.replace("@","");
                        String vTpKolom; // default
                        
                        switch(vTipeKolom){
                            case "t":
                                vTpKolom = "text";
                                break;
                            case "p":
                                vTpKolom = "password";
                                break;
                            case "h":
                                vTpKolom = "hidden";
                                break;
                            default:
                                vTpKolom = "text";
                                break;
                        }
                        
                        /* iterasi input */
                        if(jKol > 1){
                            /* sub iterasi, satu baris lebih dari 1 kolom */
                            vSb.append("<tr><td>");
                            vSb.append(vLabelKolom);
                            vSb.append("</td>");
                            
                            for(j=0;j<jKol;j++){
                                 /* text */
                                vSb.append("<td><input type=\"");
                                vSb.append(vTpKolom);
                                vSb.append("\" name=\"fnm");
                                vSb.append(vArrNmKolom[j]);
                                vSb.append("\" id=\"id");
                                vSb.append(vArrNmKolom[j]);
                                vSb.append("\" value=\"");
                                vSb.append(vArrNlKolom[j]);
                                vSb.append("\" /></td> ");
                            }
                            
                            vSb.append("</tr>");
                            
                        }else{
                            /* 1 baris hanya 1 kolom */
                            vSb.append("<tr><td class=\"clsLabel\"><label for=\"");
                            vSb.append(vLabelKolom);
                            vSb.append("\">");
                            vSb.append(vLabelKolom);
                            vSb.append("</label></td><td><input type=\"");
                            vSb.append(vTpKolom);
                            vSb.append("\" name=\"nm");
                            vSb.append(vArrNmKolom[j].replaceAll("!","").replaceAll(">",""));
                            vSb.append("\" id=\"id");
                            vSb.append(vArrNmKolom[j].replaceAll("!","").replaceAll(">",""));
                            vSb.append("\" value=\"");
                            vSb.append(vArrNlKolom[j].replaceAll("!","").replaceAll(">",""));
                            vSb.append("\" ");
                            
                            if(vArrNmKolom[j].substring(0,1).equals("!")){
                                vSb.append("disabled");
                            }
                            
                            if(vArrNmKolom[j].substring(0,1).equals(">")){
                                vSb.append("readonly");
                            }
                            
                            vSb.append(" /></td></tr>\r\n");
                        }
                        
                        break;
                    case "a":
                        /* 1 baris hanya 1 kolom */
                        vSb.append("<tr><td class=\"clsLabelTextArea\"><label for=\"");
                        vSb.append(vLabelKolom);
                        vSb.append("\">");
                        vSb.append(vLabelKolom);
                        vSb.append("</label></td><td><textarea");
                        vSb.append(" name=\"fnm");
                        vSb.append(vArrNmKolom[j]);
                        vSb.append("\" id=\"id");
                        vSb.append(vArrNmKolom[j]);
                        vSb.append("\">");
                        vSb.append(vArrNlKolom[j]);
                        vSb.append("</textarea></td></tr>\r\n");
                        break;
                        
                    case "r":
                        /* radio input */
                        /* masukan input */
                        /* A&nA#B&nB*/
                        /* sub iterasi, satu bari lebih dari 1 kolom */
                        vSb.append("<tr><td class=\"clsLabel\"><label for=\"");
                        vSb.append(vLabelKolom);
                        vSb.append("\">");
                        vSb.append(vLabelKolom);
                        vSb.append("</label></td><td>");
                            
                        /* radio button selalu berpasangan */
                        if(jKol > 0){
                            /* iterasi sebanyak jumlah kolom */
                            /* pisahkan label dan nilai "label&nilai" */
                            String[] vArrLblNilaiRadio = null;
                            String[] vRadio = null;
                            //String[] vRadio2 = null;
                            /* mulai membuat radio button <input type="radio" ...><label ...>*/
                            
                            /* buat tabel */
                            vSb.append("<table id=\"idTabelRadio\"><tr>");//<td>Test</td><td>Test2</td>");
                            
                            /* iterasi */
                            for(k=0;k<=jKol;k++){
                                //vSb.append(vArrNlKolom[j]);
                                vRadio = vArrNlKolom[k].split("&");
                                
                                vSb.append("<td class=\"clsTdRadio\">");
                                vSb.append("<input type=\"radio\" name=\"nm");
                                vSb.append(vArrNmKolom[j]).append("\" value=\"");
                                
                                if(vRadio[0].substring(0,1).equals("@")){
                                    vSb.append(vRadio[0].replaceAll("@",""));
                                    vSb.append("\" ");
                                    vSb.append("checked");
                                }else{
                                    vSb.append(vRadio[0]);
                                    vSb.append("\" ");
                                }
                                vSb.append(" />");
                                //vSb.append(vRadio1[0]); // nilai 0 atau 1
                                vSb.append("</td>");
                                vSb.append("<td class=\"clsTdRadioLabel\">");
                                vSb.append("<label class=\"clsLabelRadio\">");
                                vSb.append(vRadio[1]);
                                vSb.append("</label>"); // label
                                vSb.append("</td>");
                                
                                /*vRadio2 = vArrNlKolom[1].split("&");
                                vSb.append("<td class=\"clsTdRadio\">");
                                vSb.append("<input type=\"radio\" name=\"nm");
                                vSb.append(vArrNmKolom[j]).append("\" value=\"");
                                vSb.append(vRadio2[0]);
                                vSb.append("\" />");
                                vSb.append("</td>");
                                vSb.append("<td class=\"clsTdRadioLabel\">");
                                vSb.append("<label class=\"clsLabelRadio\">");
                                vSb.append(vRadio2[1]);
                                vSb.append("</label>"); 
                                vSb.append("</td>");*/
                            }
                           
                            
                            /* penutup baris */
                            vSb.append("</tr></table>");
                        }
                        
                        vSb.append("</td></tr>\r\n");
                        
                        break;
                    case "s":
                        /* iterasi */
                        if(jKol > 1){
                            /* sub iterasi, satu bari lebih dari 1 kolom */
                            vSb.append("<tr><td class=\"clsLabel\"><label for=\"");
                            vSb.append(vLabelKolom);
                            vSb.append("\">");
                            vSb.append(vLabelKolom);
                            vSb.append("</label></td>");
                            
                            
                            for(j=0;j<jKol;j++){
                                /* 1 baris hanya 1 select */
                                vSb.append("<td>");
                                vSb.append("<select class=\"cls");
                                vSb.append(vArrNmKolom[j]);
                                vSb.append("\" name=\"nm");
                                vSb.append(vArrNmKolom[j]);
                                vSb.append("\" id=\"id");
                                vSb.append(vArrNmKolom[j]);
                                vSb.append("\">");
                            
                                /* option */
                                vArrSubNlKolom = vArrNlKolom[j].split("%");
                                k = vArrSubNlKolom.length;
                                /* bila ada anggota option*/
                                if(k>0){
                                    /* iterasi option */
                                    for(String vSubNlKolom: vArrSubNlKolom){
                                        vArrOptionKolom = vSubNlKolom.split(">");
                                        vSb.append("<option value=\"");
                                        
                                        if(vArrOptionKolom[0].substring(0,1).equals("#")){
                                            vSb.append(vArrOptionKolom[0].replaceAll("#",""));
                                        }else{
                                            vSb.append(vArrOptionKolom[0]);
                                        }
                                        vSb.append("\" ");
                                        if(vArrOptionKolom[0].substring(0,1).equals("#")){
                                            vSb.append(" selected ");
                                        }
                                        vSb.append("\">");
                                        vSb.append(vArrOptionKolom[1]);
                                        vSb.append("</option>");
                                    }
                                }                            
                                /* penutup select */
                                vSb.append("</select> ");
                                vSb.append("</td>");
                            }
                            
                            vSb.append("</tr>\r\n");
                            
                        }else{
                            /* 1 baris hanya 1 select */
                            vSb.append("<tr><td class=\"clsLabel\"><label for=\"");
                            vSb.append(vLabelKolom);
                            vSb.append("\">");
                            vSb.append(vLabelKolom);
                            vSb.append("</label></td><td>");
                            vSb.append("<select class=\"cls");
                            vSb.append(vNamaKolom.replaceAll("!", ""));
                            vSb.append("\" name=\"nm");
                            vSb.append(vNamaKolom.replaceAll("!", ""));
                            vSb.append("\" id=\"id");
                            vSb.append(vNamaKolom.replaceAll("!", ""));
                            vSb.append("\" ");
                             /* disable select dengan karakter ! pada variabel name */
                            if(vNamaKolom.substring(0,1).equals("!")){
                                vSb.append(" disabled ");
                            }
                            vSb.append(">");
                            
                            /* option */
                            vArrSubNlKolom = vNilaiKolom.split("%");
                            k = vArrSubNlKolom.length;
                            /* bila ada anggota option*/
                            if(k>0){
                                /* iterasi option */
                                for(String vSubNlKolom : vArrSubNlKolom){
                                    vArrOptionKolom = vSubNlKolom.split(">");
                                    
                                    vSb.append("<option value=\"");
                                    
                                    /* selected biasa */
                                    if(vArrOptionKolom[0].substring(0,1).equals("#")){
                                        vSb.append(vArrOptionKolom[0].replaceAll("#",""));
                                    }else{
                                        vSb.append(vArrOptionKolom[0]);
                                    }  
                                                                        
                                    vSb.append("\" ");
                                    
                                    if(vArrOptionKolom[0].substring(0,1).equals("#")){
                                        vSb.append(" selected ");
                                    }
                                                                        
                                    vSb.append("\">");
                                    vSb.append(vArrOptionKolom[1]);
                                    vSb.append("</option>");
                                }
                            } 
                            
                            /* penutup select */
                            vSb.append("</select> ");
                            //vSb.append("</div>");
                            vSb.append("</td></tr>\r\n");
                            
                            /* 
                                contoh: <select name="s">
                                        <option name="a">A</option>
                                        <option name="b">B</option>
                                    </select>
                                maka data masukan berupa:
                                {"a&A%b&B"}
                            */
                        }
                        break;
                }
                /* naikkan indeks */
                i += 1;
            }
            /* akhiri form */
            vSb.append("</table>\r\n");
            vSb.append(vFTombol);
            vSb.append("</form>\r\n");
            
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsHTML.java";
                String vNamaMetode = "fForm";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        /* keluaran akhir */
        return vSb.toString();
    }
    
    public String fFormYaTidak(
            String vMethod,
            String vFURLAction, 
            String vFKalimat, 
            String vFIdTabel, 
            String[] vFArrIdTombolYaTidak,
            String[] vFArrLabelYaTidak,
            String[] vFArrGambarTombolYaTidak,
            String vFIdCSS,
            String vFClassCSS,
            String[] vArrIdDataRef){
        
        StringBuilder vSb = new StringBuilder();
        
        try{
            String vTombolYa = this.fTombol("bnt", vFArrIdTombolYaTidak[0], vFArrLabelYaTidak[0], vFArrGambarTombolYaTidak[0]);
            String vTombolTidak = this.fTombol("bnt", vFArrIdTombolYaTidak[1], vFArrLabelYaTidak[1], vFArrGambarTombolYaTidak[1]);
            vSb.append("<form id=\"");
            vSb.append(vFIdCSS);
            vSb.append("\" class=\"");
            vSb.append(vFClassCSS);
            vSb.append("\" method=\"");
            vSb.append(vMethod);
            vSb.append("\" action=\"");
            vSb.append(vFURLAction);
            vSb.append("\">\r\n");

            vSb.append("<table id=\"").append(vFIdTabel).append("\">\r\n");

            vSb.append("<tr>");
            vSb.append("<td colspan=\"3\"><center>");
            vSb.append(vFKalimat);
            vSb.append("</center></td>");
            vSb.append("</tr>\r\n");

            vSb.append("<tr>");
            vSb.append("<td colspan=\"3\">");
            vSb.append("&nbsp");
            vSb.append("</td>");
            vSb.append("</tr>\r\n");

            vSb.append("<tr>");
            vSb.append("<td></td>");
            vSb.append("<td style=\"width:90px\">").append(vTombolYa).append("</td>");
            vSb.append("<td style=\"width:90px\">").append(vTombolTidak).append("</td>");
            vSb.append("</tr>\r\n");

            vSb.append("</table>\r\n");
            vSb.append("<div style=\"display:none;\">");
            vSb.append("<input type=\"text\" id=\"").append(vArrIdDataRef[0]).append("\" value=\"").append(vArrIdDataRef[1]).append("\">");
            vSb.append("</div>");
            vSb.append("</form>");
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsHTML.java";
                String vNamaMetode = "fFormYaTidak";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        /* nilai keluaran */
        return vSb.toString();
    }
    
    public String fTombol(String vFTipe, String vFIdTombol, String vFLabel,String vFGambarTombol){
        StringBuilder vSb = new StringBuilder();
        
        try{
            switch(vFTipe){
                case "bt":
                    vSb.append("<table id=\"idTabelTombol\">");
                    vSb.append("<tr><td style=\"text-align:right;\">");
                    vSb.append("<button id=\"").append(vFIdTombol).append("\">");
                    vSb.append("<img id=\"idGbrTombol\" src=\"");
                    vSb.append(ClsKonf.vKonfURLDesainHalamanAdPubGambarTombol).append("/").append(vFGambarTombol);
                    vSb.append("\" />");
                    vSb.append(vFLabel);
                    vSb.append("</button>");
                    vSb.append("</td></tr>");
                    vSb.append("</table>\r\n");
                    break;
                case "bnt":                
                    vSb.append("<button id=\"").append(vFIdTombol).append("\">");
                    vSb.append("<img id=\"idGbrTombol\" src=\"");
                    vSb.append(ClsKonf.vKonfURLDesainHalamanAdPubGambarTombol).append("/").append(vFGambarTombol);
                    vSb.append("\" />");
                    vSb.append(vFLabel);
                    vSb.append("</button>");
                    break;
                case "s":
                    vSb.append("<table class=\"");
                    vSb.append(this.vPrvClassCSS);
                    vSb.append("\">");
                    vSb.append("<tr><td>");
                    vSb.append("<input type=\"submit\" value=\"");
                    vSb.append(vFLabel);
                    vSb.append("\" />");
                    vSb.append("</td></tr>");
                    vSb.append("</table>\r\n");
                    break;
            }
        }catch(Exception e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsHTML.java";
                String vNamaMetode = "fTombol";
                String vCatatan = vNamaKelas + "#" + vNamaMetode + "#" + e.toString();
                /* obyek catat */
                ClsCatat oCatat = new ClsCatat();
                oCatat.fCatatSistem(ClsKonf.vKonfCatatKeOutput, 
                        ClsKonf.vKonfCatatKeBD, 
                        ClsKonf.vKonfCatatKeBerkas, 
                        vCatatan);
            }
        }
        return vSb.toString();
    }    
}