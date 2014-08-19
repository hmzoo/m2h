package m2h.markdown;

class Out{

	public static var title:String="";
	public static var subtitles:Array<String>=[];
	public static var ressources:Array<String>=[];



	public static function write(s:Section):String{

		title="";
		subtitles=[];
		ressources=[];
		var result="";

		switch (Config.format){


			case "html" :
			result= html_tags(s);


		}

		return result;

	} 







	public static function html_tags(s:Section):String{


		var result="";

		var childs=s.getChilds();
		for(n in 0...childs.length){
			result=result+html_tags(childs[n]);
		}



		switch(s.getType()){

			case "PARA":
			result="<p>"+result+"</p>\n";
			case "EMPTY":
			result="";
			case "TEXT":
			result=StringTools.htmlEscape(s.getContent());
			case "HTML":
			result=s.getContent();
			case "BR":
			result="<br />\n";
			case "HR":
			result="<hr />\n";
			case "PAGEBREAK":
			result="<div class='pagebreak'></div>\n";
			case "H1":
			if(title==""){title=result;}
			result="<h1>"+result+"</h1>\n";
			case "H2":
			subtitles.push(result);
			result="<a name="+StringTools.urlEncode(result)+"><h2>"+result+"</h2></a>\n";
			case "H3":
			result="<h3>"+result+"</h3>\n";
			case "H4":
			result="<h4>"+result+"</h4>\n";
			case "H5":
			result="<h5>"+result+"</h5>\n";
			case "H6":
			result="<h6>"+result+"</h6>\n";
			case "STROKE":
			result="<b>"+result+"</b>";
			case "EMPHASYS":
			result="<i>"+result+"</i>";
			case "CODE":
			result="<code>"+StringTools.htmlEscape(s.getContent())+"</code>";
			case "TASK":
			var taskstate="tasknotdone";
			if(s.getAtt("state")=="1"){taskstate="taskdone";}
			result="<div class='"+taskstate+"'>"+s.getAtt("task")+"</div>\n";
			case "UL":
			result="<ul>"+result+"</ul>";
			case "OL":
			result="<ol>"+result+"</ol>";
			case "ULITEM":
			result="<li>"+result+"</li>";
			case "OLITEM":
			result="<li>"+result+"</li>";
			case "LINK":
			var atts:String="";
			var url=s.getAtt("url");
			if(url!=null){atts=atts+"href='"+url+"' ";ressources.push(url);}
			var title=s.getAtt("title");
			if(title!=null){atts=atts+"title='"+title+"' ";}
			result="<a "+atts+">"+result+"</a>";
			case "IMAGE":
			var atts:String="";
			var src=s.getAtt("src");
			if(src!=null){atts=atts+"src='"+src+"' ";ressources.push(src);}
			var title=s.getAtt("title");
			if(title!=null){atts=atts+"title='"+title+"' ";}
			result="<img "+atts+" />";
			case "BLOCKQUOTE":
			result="<blockquote>"+result+"</blockquote>\n";
			case "CODEBLOCK":
			result="<pre><code>"+StringTools.htmlEscape(s.getContent())+"</code></pre>\n";
			case "TABLE":
			result="<table>"+result+"</table>";
			case "THEAD":
			result="<thead>"+result+"</thead>";
			case "TBODY":
			result="<tbody>"+result+"</tbody>";
			case "TR":
			result="<tr>"+result+"</tr>";
			case "TD":
			var atts:String="";
			var align=s.getAtt("align");
			if(align!=null){atts=atts+"align='"+align+"' ";}
			result="<td "+atts+">"+result+"</td>";
			case "TH":
			var atts:String="";
			var align=s.getAtt("align");
			if(align!=null){atts=atts+"align='"+align+"' ";}
			result="<th "+atts+">"+result+"</th>";

		}

		return result;


	}







}

