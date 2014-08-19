package m2h.tree;

import m2h.markdown.Rmd;
import m2h.markdown.Out;


class Crawler{
	
static var mdExt:Array<String>=["md","markdown", "mdown", "mkdn", "mkd"];

public static function getArbo(path){

var arbo=new Arbo(null,path);

crawlDir(path,arbo);

return arbo;


}


static function crawlDir(path:String,arbo:Arbo){


		
		try{
			var files=Fs.list(path);

			files=files.filter( isNotDraft);

			for (i in 0...files.length){

				Fs.checkFileName( files[i]);

				var filepath=Fs.join([path,files[i]]);

				
				
				if(Fs.isdir(filepath)){
					if(Fs.list(filepath)!=null){
						

						var newArbo=arbo.createArbo(files[i]);			

						crawlDir( filepath,newArbo );

					}
					}else{
												

						var tabex=files[i].split(".");
						var format="";
						var simpleName="";
						if(tabex.length>1){format=tabex[tabex.length-1];simpleName=tabex[tabex.length-2]; }
						if(isMarkdownFile(format)){

							var md=Fs.load(filepath);

							if(md!=null){
								

								var newLeaf:Leaf;

								if(simpleName.toLowerCase()=="index"){
									
																	newLeaf=arbo.getIndex();
								}else{
									newLeaf=arbo.createLeaf(files[i]);
								}

								newLeaf.setSimpleName(simpleName);
								newLeaf.setContent( Out.write(Rmd.parse(md)) );
								newLeaf.setTitle(Out.title);
								newLeaf.setSubtitles(Out.subtitles);
								newLeaf.setRessources(Out.ressources);
								

							}

						}
					}
				}	
				
			//
			}catch( msg : String ) {
				trace("Error occurred: " + msg);
			}
		}



		static function isMarkdownFile(ext:String):Bool{
			ext=ext.toLowerCase();
			for(n in 0...mdExt.length){if(mdExt[n]==ext){return true;}}
			return false;

		}

		static function isNotDraft(f:String):Bool{



			return !(StringTools.startsWith(f,"_")||StringTools.startsWith(f,"."));

		}

	







}