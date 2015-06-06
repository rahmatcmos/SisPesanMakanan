/* Nama berkas: ClsBerkasXML.java
 * Fungsi: menangani pembacaan berkas XML
 * Pemrogram: I Made Ariana 
 * Hari,tanggal,jam: Senin, 02 Maret 2015, 22.00 WIB
 * E-mail: i.made43@ui.ac.id / made.ariana@mail.ugm.ac.id
 */

package pilar.cls;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.w3c.dom.Node;
import org.w3c.dom.Element;
import java.io.File;
import java.io.IOException;
import javax.xml.parsers.ParserConfigurationException;
import org.w3c.dom.DOMException;
import org.xml.sax.SAXException;

public class ClsBerkasXML{
    
    /* ################################################
     * fKonfBasisdata: membaca konfigurasi basisdata dari berkas (XML).
     * Parameter Masukan:
     * 1) vFNamaBerkas (String): nama berkas (XML) yang dibaca.
     * 2) vFNamaBD (String): nama basisdata.
     * Keluaran:
     * 1) vKeluaran (String[]): [0] alamat IP [1] port [2] nama basisdata [3] pengguna [4] sandi
        ################################################ */
    public String[] fKonfBasisdata(String vFNamaBerkas, String vFNamaBD) 
    throws DOMException, SAXException, ClassNotFoundException, ParserConfigurationException, IOException{
        String vDataKoneksiBD[] = new String[5];           
        
        File fXmlFile;
        if(vFNamaBerkas.equals("")){
            fXmlFile = new File(ClsKonf.vKonfDirBd + File.separator + ClsKonf.vKonfBerkasBdStd + ".xml");            
        }else{
            fXmlFile = new File(ClsKonf.vKonfDirBd + File.separator + vFNamaBerkas + ".xml");            
        }
        
        DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
        DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
        Document doc = dBuilder.parse(fXmlFile);

        doc.getDocumentElement().normalize();
        NodeList nList = doc.getElementsByTagName("bd");

            for (int temp = 0; temp < nList.getLength(); temp++) {
                Node nNode = nList.item(temp);
                    if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                        Element eElement;                            
                        eElement = (Element) nNode;                            
                        if(eElement.getAttribute("nama").equals(vFNamaBD)){
                            vDataKoneksiBD[0] = eElement.getElementsByTagName("alamatIP").item(0).getTextContent();
                            vDataKoneksiBD[1] = eElement.getElementsByTagName("port").item(0).getTextContent();
                            vDataKoneksiBD[2] = eElement.getElementsByTagName("namaBD").item(0).getTextContent();
                            vDataKoneksiBD[3] = eElement.getElementsByTagName("namaID").item(0).getTextContent();
                            vDataKoneksiBD[4] = eElement.getElementsByTagName("sandiID").item(0).getTextContent();
                        }
                    }
            }        
        /* nilai keluaran akhir */  
        return vDataKoneksiBD;
    }
    
    /* ################################################
     * fKolomTabel: mengeluarkan data berupa rangkaian kolom dalam sebuah tabel.
     * Parameter Masukan:
     * 1) vFNamaBD (String): nama basisdata.
     * 2) vFNamaTabel (String): nama tabel.
     * Keluaran:
     * 1) vKeluaran (String[]): [0] indeks kolom [1] nama kolom (db.tbl.kolom1,db.tbl.kolom2,dst.).
        ################################################ */
    public String[] fKolomTabel(String vFNamaBD, String vFNamaTabel){
        String vArrDataTabel[] = new String[2];
        
        try{
                      
            vFNamaBD = (vFNamaBD.equals("")) ? ClsKonf.vKonfBdStd : vFNamaBD;

            String vLetakBerkas = ClsKonf.vKonfDirBd + File.separator + vFNamaBD;           

            File fXmlFile;
            fXmlFile = new File(vLetakBerkas + File.separator + vFNamaTabel + ".xml");

            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(fXmlFile);

                doc.getDocumentElement().normalize();
                NodeList nList = doc.getElementsByTagName("tb");

                for (int temp = 0; temp < nList.getLength(); temp++) {
                        Node nNode = nList.item(temp);
                        //System.out.println("\nCurrent Element :" + nNode.getNodeName());
                        if (nNode.getNodeType() == Node.ELEMENT_NODE) {
                                Element eElement;                            
                                eElement = (Element) nNode; 

                                if(eElement.getAttribute("nama").equals(vFNamaTabel)){                                
                                    vArrDataTabel[0] = eElement.getElementsByTagName("indeks").item(0).getTextContent();
                                    vArrDataTabel[1] = eElement.getElementsByTagName("kolom").item(0).getTextContent();
                                 }
                        }
                }

            /* olah data kolom tabel */
            String vArrKolom[] = vArrDataTabel[1].split(",");

            StringBuilder vSbKolom = new StringBuilder();
            boolean vKolomPertama = true;

            /* nama bd & tabel */
            vSbKolom.append("`");
            vSbKolom.append(vFNamaBD);
            vSbKolom.append("`.");
            vSbKolom.append("`");
            vSbKolom.append(vFNamaTabel);
            vSbKolom.append("`.");

            for(String vKolom : vArrKolom){
                if(vKolomPertama){
                    vSbKolom.append("`");
                    vSbKolom.append(vKolom);
                    vSbKolom.append("`");
                    /* tandai kolom pertama sudah lewat */
                    vKolomPertama = false;
                }else{

                    vSbKolom.append(",`");
                    vSbKolom.append(vKolom);
                    vSbKolom.append("`");
                }
            }
            vArrDataTabel[1] = vSbKolom.toString();
        }catch(ParserConfigurationException | SAXException | IOException | DOMException e){
            /* pencatatan sistem */
            if(ClsKonf.vKonfCatatSistem == true){
                String vNamaKelas = "ClsBerkasXML.java";
                String vNamaMetode = "fKolomTabel";
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
        return vArrDataTabel;
  }
    
  
}
