package m2h.html;

import mustache.Mustache;
import m2h.tree.Arbo;
import m2h.tree.Leaf;
import m2h.tree.Crawler;
import m2h.markdown.Out;
import m2h.markdown.Rmd;

class Site{

	static var siteName:String;
	static var siteSlogan:String;
	static var pathIn:String;
	static var pathOut:String;
	static var mainArbo:Arbo;




	static var mdExt:Array<String>=["md","markdown", "mdown", "mkdn", "mkd"];



	public static function build(){
		Site.siteName=Config.siteName;
		Site.siteSlogan=Config.siteSlogan;
		Site.pathIn=Config.pathIn;
		Site.pathOut=Config.pathOut;

		mainArbo = Crawler.getArbo(pathIn);
		mainArbo.getIndex().setTitle(siteName);

		
		buildOutDirectory();

		Page.siteName=siteName;
		Page.siteSlogan=siteSlogan;
		Page.pageTemplate=Config.templatemustache;

		
		buildArbo(mainArbo);

	}


	static function buildOutDirectory(){
		Fs.mkdir(pathOut);

		if(!Fs.exists( pathOut+"/_markdown.css")||Config.forceRebuild){
			Fs.save (pathOut+"/_markdown.css",Config.markdowncss);
		}

		if(!Fs.exists( pathOut+"/_style.css")||Config.forceRebuild){

			Fs.save (pathOut+"/_style.css",Config.stylecss);
		}

		if(!Fs.exists( pathOut+"/_template.mustache")||Config.forceRebuild){
			Fs.save (pathOut+"/_template.mustache",Config.templatemustache);
		}

		if(!Fs.exists( pathOut+"/favicon.ico")||Config.forceRebuild){
			Fs.saveBytes (pathOut+"/favicon.ico",Config.favicon_ico);
		}

		if(!Fs.exists( pathOut+"/favicon.png")||Config.forceRebuild){
			Fs.saveBytes (pathOut+"/favicon.png",Config.favicon_png);
		}

	}



	

	

	



	static public function buildUrl(l:Leaf):String{

		

		var path:Array<String>=l.getParent().getPath([l.getSimpleName()]);

		path.shift();

		var flatUrl=path.join("_");

		flatUrl=~/^_/.replace(flatUrl,"");
		flatUrl=~/\s/gu.replace(flatUrl,"-");
		flatUrl=~/[ËÊÈÉéèëê]/gu.replace(flatUrl,"e");
		flatUrl=~/[ÄÂÀÁäâàá]/gu.replace(flatUrl,"a");
		flatUrl=~/[ÏÎÌÍïîìí]/gu.replace(flatUrl,"i");
		flatUrl=~/[ÖÔÒÓöôòó]/gu.replace(flatUrl,"o");
		flatUrl=~/[ÜÛÙÚüûùúµ]/gu.replace(flatUrl,"u");
		flatUrl=~/[ç]/gu.replace(flatUrl,"c");
		flatUrl=~/[^0-9A-Z\.\-]/igu.replace(flatUrl,"_");

		flatUrl=flatUrl.toLowerCase();
		flatUrl=flatUrl+".html";

		return flatUrl;


	} 






	static public function buildArbo(arbo:Arbo){

	

	if(arbo.getIndex().getContent()==null){buildIndex(arbo);}

		var arbos:Iterator<Arbo>=arbo.getChildsIterator();
		var leaves:Iterator<Leaf>=arbo.getLeavesIterator();

	

		var page=new Page(arbo.getIndex());


		//trace(Fs.join([pathOut,buildUrl(arbo.getIndex())]));

		Fs.save (Fs.join([pathOut,buildUrl(arbo.getIndex())]),page.html());
		copyRessources(arbo.getIndex());
		

		for(l in leaves){

			var page=new Page(l);
			
			Fs.save (Fs.join([pathOut,buildUrl(l)]),page.html());

			copyRessources(l);
	

		}



		for(a in arbos){
			
			buildArbo(a);
		}




	}



static function copyRessources(l:Leaf){

		var r=l.getRessources();
		

			for (n in 0...r.length){

				
  
				Fs.copy(Fs.join(l.getParent().getPath([r[n]])), Fs.join([pathOut,r[n]]));
			}


}



	static function buildIndex(arbo:Arbo){




		var dirList="";

		var fileList="";


		var arbos:Iterator<Arbo>=arbo.getChildsIterator();
		var leaves:Iterator<Leaf>=arbo.getLeavesIterator();

		for(a in arbos){

			

				dirList=dirList+"<tr><td><a href='"+buildUrl(a.getIndex())+"' >"+a.getTitle()+"</a></td><td>\n";
				dirList=dirList+"<ul>";
				for(aa in a.getChildsIterator()){
				
						dirList=dirList+"<li><a href='"+buildUrl(aa.getIndex())+"' >"+aa.getTitle()+"</a></li>";
				
				}
				dirList=dirList+"</ul>";
				dirList=dirList+"</td></tr>";
			}




		for(l in leaves){
				fileList=fileList+"<tr><td><a href='"+buildUrl(l)+"' >"+l.getTitle()+"</a></td><td>\n";
				var sbt=l.getSubtitles();
				if(sbt.length>0){
					fileList=fileList+"<ul>";

					for(s in 0...sbt.length){fileList=fileList+"<li><a href='"+buildUrl(l)+"#"+StringTools.urlEncode( sbt[s])+"' >"+sbt[s]+"</a></li>";}
					fileList=fileList+"</ul>";
				}
				fileList=fileList+"</td></tr>";
			}

		


		if(fileList!=""){fileList="<div id='index_files_list'><table>"+fileList+"</table></div>";}
		if(dirList!=""){dirList="<div id='index_directories_list'><table>"+dirList+"</table></div>";}
		var indexContent=fileList+dirList;

	

		var indexLeaf=arbo.getIndex();
		
		indexLeaf.setContent(indexContent);
		




	}















}