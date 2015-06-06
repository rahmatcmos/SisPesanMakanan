/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pilar.cls;

/**
 *
 * @author PERSEUS
 */
public class ClsCatat {
    public void fCatatSistem(boolean vFCatatKeOutput,
            boolean vFCatatKeBD,
            boolean vFCatatKeBerkas, 
            String vFString){
        if(vFCatatKeOutput == true){
            System.out.println(vFString);
        }
    }
}
