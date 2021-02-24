using System;
using System.Collections.Generic;
using System.Text;

namespace FaceGenEslIfify
{
    public class NPCForm
    {
        private string _PluginName;
        public string PluginName
        {
            get { return _PluginName; }
            set { SetPluginName(value); }
        }

        public string _FormIDPre;
        public string FormIDPre
        {
            get { return _FormIDPre; }
            set { SetFormIDPre(value); }
        }

        public string _FormIDPost;
        public string FormIDPost
        {
            get { return _FormIDPost; }
            set { SetFormIDPost(value); }
        }

        public string EDID { get; set; }

        private bool IsEsl = false;

        public NPCForm() { }

        public NPCForm(string pluginName, string formIDPre, string edid)
        {
            SetPluginName(pluginName);
            SetFormIDPre(formIDPre);
            EDID = edid;
        }

        public NPCForm(string pluginName, bool s, string edid, string formIDPost)
        {
            SetPluginName(pluginName);
            SetFormIDPost(formIDPost);
            EDID = edid;
        }

        public void SetPluginName(string pluginName)
        {
            if (pluginName.Substring(pluginName.IndexOf('[') + 1, pluginName.IndexOf(']') - pluginName.IndexOf('[') - 1).Replace(" ", "").Length > 2)
            {
                IsEsl = true;
            }
            _PluginName = pluginName.Substring(pluginName.IndexOf(']') + 2);
        }

        public void SetFormIDPre(string formIDPre)
        {
            if (IsEsl)
            {
                _FormIDPre = "00000" + formIDPre.Remove(0, 5);
            }
            else
            {
                _FormIDPre = "00" + formIDPre.Remove(0, 2);
            }
        }

        public void SetFormIDPost(string formIDPost)
        {
            if (IsEsl)
            {
                _FormIDPost = "00000" + formIDPost.Remove(0, 5);
            }
            else
            {
                _FormIDPost = "00" + formIDPost.Remove(0, 2);
            }
        }

    }

}
