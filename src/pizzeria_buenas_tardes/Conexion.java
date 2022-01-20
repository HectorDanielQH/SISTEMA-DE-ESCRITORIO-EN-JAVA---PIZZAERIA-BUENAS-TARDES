/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pizzeria_buenas_tardes;


import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.ResultSet;
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author hdani
 */
public class Conexion {
    private Connection Conexion;
    private String user="hector";
    private String password="0000";
    private String driver="com.mysql.cj.jdbc.Driver";
    private String Direccion="jdbc:mysql://127.0.0.1:3306/pizzeria_buenas_tardes?serverTimezone=UTC";
    public Conexion(){
        try{
            Class.forName(driver);
            Conexion=(Connection)DriverManager.getConnection(Direccion,user,password);
            if(Conexion!=null){
                //JOptionPane.showMessageDialog(null,"CONEXION EXITOSA");
            }
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "ERROR DE CONEXION" + e);
        }
    }
    
    public String Validacion(String username,String password){
        String sql="call VALIDATE_USER(?,?,?)";
        String mensaje="";
        try{
            CallableStatement call=Conexion.prepareCall(sql);
            call.setString(1, username);
            call.setString(2, password);
            call.registerOutParameter(3, java.sql.Types.VARCHAR);
            call.execute();
            mensaje=call.getString(3);
            call.close();
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "EXISTIO UN ERROR DE VALIDACION");
        }
        finally{
            return mensaje;
        }
    }
    public void Mostrar_menu(JTable tabla){
        String sql="select * from vista_administrador_menu;";
        try{
            Statement st=Conexion.createStatement();
            ResultSet resultado=st.executeQuery(sql);
            DefaultTableModel modelo_tabla=new DefaultTableModel();
            modelo_tabla.addColumn("CODIGO MENU");
            modelo_tabla.addColumn("DESCRIPCION");
            modelo_tabla.addColumn("PRECIO");
            modelo_tabla.addColumn("TAMAÑO");
            modelo_tabla.addColumn("IMAGEN");
            while(resultado.next()){
                modelo_tabla.addRow(new Object[]{resultado.getString(1),resultado.getString(2),resultado.getFloat(3),resultado.getString(4),resultado.getString(5)});
            }
            
            tabla.setModel(modelo_tabla);
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "EXISTIO UN ERROR DE CONSULTA" + e);
        }
    }
    public void Insertar_menu(String descripcion,String Precio, String Tamano, String Ruta){
        String sql="call INSERTAR_MENU(?,?,?,?,?)";
        String mensaje="";
        String Carp_actual=System.getProperty("user.dir")+"\\src\\imagen\\"+"FOTO_BASE"+Math.random()+Ruta.substring(Ruta.length()-4,Ruta.length());
        
        Path origen=FileSystems.getDefault().getPath(Ruta);
        Path destino=FileSystems.getDefault().getPath(Carp_actual);
        try{
            CallableStatement call=Conexion.prepareCall(sql);
            call.setString(1, descripcion);
            call.setFloat(2, Float.parseFloat(Precio));
            call.setString(3, Tamano);
            call.setString(4, destino.toString());
            call.registerOutParameter(5, java.sql.Types.VARCHAR);
            call.execute();
            mensaje=call.getString(5);
            call.close();
            JOptionPane.showMessageDialog(null, mensaje);
            Files.copy(origen, destino,StandardCopyOption.REPLACE_EXISTING);
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "NO SE PUDO INSERTAR EL MENU DE MANERA CORRECTA"+ e);
        }
    }
    public void Mostrar_venta_realizada_por_encargados(){
        String sql="select * from vista_administrador_venta_realizada_por_encargados;";
        try{
            Statement st=Conexion.createStatement();
            ResultSet resultado=st.executeQuery(sql);
            while(resultado.next()){
                System.out.println(resultado.getString(1) + resultado.getString(2)+ resultado.getString(3)+
                        resultado.getString(4) + resultado.getString(5)+resultado.getString(6)+resultado.getString(7)
                        +resultado.getString(8) + resultado.getString(9) + resultado.getString(10) + resultado.getString(11) + 
                        resultado.getString(12)
                );
            }
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "EXISTIO UN ERROR DE VISUALIZACION " + e);
        }
    }
    
    public void Crear_cliente(String CI_NIT, String NOMBRE, String APELLIDO, String Direccion){
        String sql="call INSERTAR_CLIENTE(?,?,?,?,?);";
        String mensaje="";
        try{
            try (CallableStatement call = Conexion.prepareCall(sql)) {
                call.setString(1, CI_NIT);
                call.setString(2, NOMBRE);
                call.setString(3, APELLIDO);
                call.setString(4, Direccion);
                call.registerOutParameter(5, java.sql.Types.VARCHAR);
                call.execute();
                mensaje=call.getString(5);
            }
            JOptionPane.showMessageDialog(null, mensaje);
        }
        catch(Exception e){
            JOptionPane.showMessageDialog(null, "EXISTIO UN ERROR DE INSERSION " + e);
        }
    }
    
    
}
