using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;

namespace FaceGenEslIfify
{
    public static class Program
    {
        public static SortedDictionary<string, NPCForm> FormList = new SortedDictionary<string, NPCForm>();
        public static Settings config;
        public static void Main(string[] args)
        {
            config = SettingsJson.GetConfig();
            try
            {
                if (File.Exists($"{config.xEditFolder}\\FaceGenEslify\\xEditOutput\\_1PreEslify.csv"))
                {
                    Console.WriteLine($"_1PreEslify.csv found.");
                    using (var reader = new StreamReader($"{config.xEditFolder}\\FaceGenEslify\\xEditOutput\\_1PreEslify.csv"))
                    {
                        reader.ReadLine();
                        while (!reader.EndOfStream)
                        {
                            string[] csvArr = reader.ReadLine().Split(';');
                            NPCForm nPCForm = new NPCForm(csvArr[0], csvArr[1], csvArr[2]);
                            FormList.Add(nPCForm.PluginName + ";" + nPCForm.EDID, nPCForm);
                        }
                    }

                    if (File.Exists($"{config.xEditFolder}\\FaceGenEslify\\xEditOutput\\_2PostEslify.csv"))
                    {
                        Console.WriteLine("_2PostEslify.csv found.");
                        using (var reader = new StreamReader($"{config.xEditFolder}\\FaceGenEslify\\xEditOutput\\_2PostEslify.csv"))
                        {
                            reader.ReadLine();
                            while (!reader.EndOfStream)
                            {
                                string[] csvArr = reader.ReadLine().Split(';');
                                NPCForm nPCForm = new NPCForm(csvArr[0], true, csvArr[2], csvArr[1]);
                                FormList.GetValueOrDefault(nPCForm.PluginName + ";" + nPCForm.EDID).IsEsl = nPCForm.IsEsl;
                                FormList.GetValueOrDefault(nPCForm.PluginName + ";" + nPCForm.EDID).SetFormIDPost(nPCForm.FormIDPost);
                            }
                        }
                        IDictionaryEnumerator myEnumerator = FormList.GetEnumerator();
                        if (config.RenameTint)
                        {
                            while (myEnumerator.MoveNext())
                            {
                                SetMeshFaceGen((NPCForm)(myEnumerator.Value));
                                SetTexFaceGen((NPCForm)(myEnumerator.Value));
                            }
                        }
                        else
                        {
                            while (myEnumerator.MoveNext())
                            {
                                SetMeshFaceGen((NPCForm)(myEnumerator.Value));
                            }
                        }
                    }
                    else
                    {
                        Console.WriteLine($"_2PostEslify.csv not found.");
                        Console.WriteLine($"eslifing facegen quit.");
                        Console.Write("Press enter to close. >");
                        Console.ReadLine();
                    }
                }
                else
                {
                    Console.WriteLine($"_1PreEslify.csv not found.");
                    Console.WriteLine($"eslifing facegen quit.");
                    Console.Write("Press enter to close. >");
                    Console.ReadLine();
                }
                
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                Console.ReadLine();
            }
            Console.WriteLine("FacegenEslify done.");
            Console.WriteLine("Press enter to close. >");
            Console.ReadLine();
        }

        public static void SetMeshFaceGen(NPCForm nPCFormP)
        {
            SetMeshFaceGen(nPCFormP.PluginName, nPCFormP.FormIDPre, nPCFormP.FormIDPost);
        }

        public static void SetMeshFaceGen(string pluginName, string origonalFormID, string eslFormID)
        {
            string orgFilePath = $"{config.SkyrimDataFolder}\\meshes\\actors\\character\\facegendata\\facegeom\\{pluginName}\\{origonalFormID}.nif";
            string eslFilePath = $"{config.SkyrimDataFolder}\\meshes\\actors\\character\\facegendata\\facegeom\\{pluginName}\\{eslFormID}.nif";
            if (File.Exists(orgFilePath))
            {
                try
                {
                    Console.WriteLine("\"" + orgFilePath + "\" found.");
                    File.Move(orgFilePath, eslFilePath, true);
                    Console.WriteLine("\"" + eslFilePath + "\" replaced origonal.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.ReadLine();
                }
            }
            else Console.WriteLine(orgFilePath+"\" not found.");
        }

        public static void SetTexFaceGen(NPCForm nPCFormP)
        {
            SetTexFaceGen(nPCFormP.PluginName, nPCFormP.FormIDPre, nPCFormP.FormIDPost);
        }

        public static void SetTexFaceGen(string pluginName, string origonalFormID, string eslFormID)
        {
            string orgFilePath = $"{config.SkyrimDataFolder}\\textures\\actors\\character\\facegendata\\facetint\\{pluginName}\\{origonalFormID}.dds";
            string eslFilePath = $"{config.SkyrimDataFolder}\\textures\\actors\\character\\facegendata\\facetint\\{pluginName}\\{eslFormID}.dds";
            if (File.Exists(orgFilePath))
            {
                try
                {
                    Console.WriteLine("\"" + orgFilePath + "\" found.");
                    File.Move(orgFilePath, eslFilePath, true);
                    Console.WriteLine("\"" + eslFilePath + "\" replaced origonal.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                    Console.ReadLine();
                }
            }
            else Console.WriteLine(orgFilePath + "\" not found.");
        }
    }
}
