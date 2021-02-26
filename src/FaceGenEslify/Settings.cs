using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace FaceGenEslIfify
{
    public static class SettingsJson
    {
        public static Settings GetConfig()
        {
            if (File.Exists(@".\config.json"))
            {
                return JsonSerializer.Deserialize<Settings>(File.ReadAllText(@".\config.json"));
            }
            else return new Settings();
        }
    }
    public class Settings
    {
        [JsonInclude]
        public string SkyrimDataFolder = @".";
        [JsonInclude]
        public string xEditFolder = @".";
        [JsonInclude]
        public bool RenameTint = false;
    }
}
