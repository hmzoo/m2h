package m2h.html;

import mustache.Mustache;
import m2h.tree.Leaf;
import m2h.tree.Arbo;


  

class Page{


	static public var pageTemplate:String;
	static public var siteName:String="";
	static public var siteSlogan:String="";

	var leaf:Leaf;


	var pageDatas:Dynamic;



	public function new(leaf:Leaf){

		this.leaf=leaf;

		var parentArbo=leaf.getParent();

		pageDatas={

		
			page_title:leaf.getTitle(),
			site_name:Page.siteName,
			site_slogan:Page.siteSlogan,
			level:Std.string(leaf.getParent().getLevel()),
			content:leaf.getContent(),
			breadcumb:"",
			date:DateTools.format(Date.now(),"%Y-%m-%d"),
			primary_directory:"",
			secondary_directory:"",
			current_directory:"",
			primary_links:"",
			secondary_links:"",
			directories_list:"",
			files_list:"",
			chapters_list:"",
			hide_files:"",
			hide_chapters:"",
			informations:Config.informations


		};

		//index
		//if (arbo.isIndex()){
		//	pageDatas.hide_files="style='display:none'";
		//	pageDatas.hide_chapters="style='display:none'";

		//}


		//titles

		
		pageDatas.current_directory=parentArbo.getTitle();

		if(pageDatas.current_directory==pageDatas.page_title){pageDatas.current_directory="";}

		var primaryArbo=parentArbo.getPrimary();
		if(primaryArbo!=null){
			pageDatas.primary_directory=primaryArbo.getTitle();
			}


		var secondaryArbo=parentArbo.getSecondary();
		if(secondaryArbo!=null){
			pageDatas.secondary_directory=secondaryArbo.getTitle();
		}

		//Breadcrumb
		var breadcumb="";
		
		var upArbo=parentArbo;


		while(upArbo!=null&&upArbo.getParent()!=null){

			breadcumb="<a href='"+Site.buildUrl(upArbo.getIndex())+"'>"+upArbo.getTitle()+"</a>"+breadcumb;

	
			upArbo=upArbo.getParent();

			}
		
		pageDatas.breadcumb=breadcumb;


	

		//file and directory lists

		var fileList="";
		var dirList="";	

				var arbos:Iterator<Arbo>=parentArbo.getChildsIterator();
				var leaves:Iterator<Leaf>=parentArbo.getLeavesIterator();

				for(a in arbos){
					dirList=dirList+"<li><a href='"+Site.buildUrl(a.getIndex())+"' >"+a.getTitle()+"</a></li>\n";
				}

				for(l in leaves){

						if(l==leaf){
						fileList=fileList+"<li class='selected' ><a class='selected' href='"+Site.buildUrl(l)+"' >"+l.getTitle()+"</a></li>\n";
						}else{
						fileList=fileList+"<li><a href='"+Site.buildUrl(l)+"' >"+l.getTitle()+"</a></li>\n";
						}

				}

		if(fileList!=""){pageDatas.files_list="<ul>"+fileList+"</ul>";}
		if(dirList!=""&&parentArbo.getLevel()>2){pageDatas.directories_list="<ul>"+dirList+"</ul>";}	

	

		//section list

		var sbt=leaf.getSubtitles();

		var sectionList="";
		for(n in 0...sbt.length){sectionList=sectionList+"<li><a href='"+Site.buildUrl(leaf)+"#"+StringTools.urlEncode( sbt[n])+"' >"+sbt[n]+"</a></li>";}
		if(sectionList!=""){pageDatas.chapters_list="<ul>"+sectionList+"</ul>";}else{pageDatas.hide_chapters="style='display:none'";}


		//primary list
		var primaryList="";
		var secondaryList="";



		var arbos:Iterator<Arbo>=parentArbo.getRoot().getChildsIterator();


		for(a in arbos){
					
						if(primaryArbo!=null&&primaryArbo==a){
						primaryList=primaryList+"<li class='selected' ><a href='"+Site.buildUrl(a.getIndex())+"' class='selected' >"+a.getTitle()+"</a></li>\n";
						}else{
						primaryList=primaryList+"<li><a href='"+Site.buildUrl(a.getIndex())+"' >"+a.getTitle()+"</a></li>\n";
						}
					
				}

		if(primaryArbo!=null){
			var arbos:Iterator<Arbo>=primaryArbo.getChildsIterator();
			for(a in arbos){
						
							if(secondaryArbo!=null&&secondaryArbo==a){
							secondaryList=secondaryList+"<li class='selected' ><a href='"+Site.buildUrl(a.getIndex())+"' class='selected' >"+a.getTitle()+"</a></li>\n";
							}else{
							secondaryList=secondaryList+"<li><a href='"+Site.buildUrl(a.getIndex())+"' >"+a.getTitle()+"</a></li>\n";
							}
						
					}

		}

		if(primaryList!=""){pageDatas.primary_links="<ul>"+primaryList+"</ul>";}
		if(secondaryList!=""){pageDatas.secondary_links="<ul>"+secondaryList+"</ul>";}

			
		

	}

	








	public function html(){

		
		
		return Mustache.render(Page.pageTemplate, pageDatas);



	}



}