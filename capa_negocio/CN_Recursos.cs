using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Security.Cryptography;

namespace capa_negocio
{
    public class CN_Recursos
    {
        //Generar clave de 8 caracteres
        public static string GenerarPassword()
        {
            string clave = Guid.NewGuid().ToString("N").Substring(0, 8);
            return clave;
        }

        //Encriptar contraseña con SHA256
        public static string EncriptarPassword(string str)
        {
            if (string.IsNullOrEmpty(str)) return string.Empty;

            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(str));

                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        private readonly string _iv = "qoeghkaihjolcxmd"; // 16 bytes para AES
        private readonly string _key = "obiwqxupdhjtwqryexzclfvknmzshypg"; // 32 bytes para AES

        public string EncryptValue(string value)
        {
            if (string.IsNullOrEmpty(value)) return string.Empty;

            try
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    byte[] clearTextBytes = Encoding.UTF8.GetBytes(value);

                    using (Aes aes = Aes.Create())
                    {
                        aes.Key = Encoding.UTF8.GetBytes(_key);
                        aes.IV = Encoding.UTF8.GetBytes(_iv);

                        using (CryptoStream cs = new CryptoStream(ms, aes.CreateEncryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(clearTextBytes, 0, clearTextBytes.Length);
                            cs.FlushFinalBlock();
                        }
                    }
                    return Convert.ToBase64String(ms.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al encriptar: {ex.Message}");
            }
        }

        public string DecryptValue(string value)
        {
            if (string.IsNullOrEmpty(value)) return string.Empty;

            try
            {
                value = value.Replace(' ', '+');
                byte[] encryptedTextBytes = Convert.FromBase64String(value);

                using (MemoryStream ms = new MemoryStream())
                {
                    using (Aes aes = Aes.Create())
                    {
                        aes.Key = Encoding.UTF8.GetBytes(_key);
                        aes.IV = Encoding.UTF8.GetBytes(_iv);

                        using (CryptoStream cs = new CryptoStream(ms, aes.CreateDecryptor(), CryptoStreamMode.Write))
                        {
                            cs.Write(encryptedTextBytes, 0, encryptedTextBytes.Length);
                            cs.FlushFinalBlock();
                        }
                    }
                    return Encoding.UTF8.GetString(ms.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw new Exception($"Error al desencriptar: {ex.Message}");
            }
        }

        //Enviar correo
        public static bool EnviarCorreo(string correo, string asunto, string mensaje)
        {
            bool resultado = false;

            try
            {
                MailMessage mail = new MailMessage();
                mail.To.Add(correo);
                mail.From = new MailAddress("kenethmacis92@gmail.com");
                mail.Subject = asunto;
                mail.Body = mensaje;
                mail.IsBodyHtml = true;

                var smtp = new SmtpClient()
                {
                    Credentials = new NetworkCredential("kenethmacis92@gmail.com", "tyiflevgpbxycgbx"),
                    Host = "smtp.gmail.com",
                    Port = 587,
                    EnableSsl = true
                };
                smtp.Send(mail);
                resultado = true;
            }
            catch (Exception)
            {
                resultado = false;
            }
            return resultado;
        }

        public string ConvertBase64(string ruta, out bool conversion)
        {
            string textoBase64 = string.Empty;
            conversion = true;

            try
            {
                byte[] bytes = File.ReadAllBytes(ruta);
                textoBase64 = Convert.ToBase64String(bytes);
            }
            catch (Exception)
            {
                conversion = false;
            }
            return textoBase64;
        }
    }
}
