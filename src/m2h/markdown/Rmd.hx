
package m2h.markdown;


class Rmd{

	public static var EMPTY = ~/^([ \t]*)$/;
	public static var CODEINDENT = ~/^([\t]|[ ]{4})(.*)$/;
	public static var LISTINDENT = ~/^([ ]{1,3})(.*)$/;
	public static var ATX_HEADER = ~/^(#{1,6})([^#]*?)#*$/;
	public static var SETEXT_HEADER = ~/^((=+)|(-+))$/;
	public static var HR = ~/^[ ]{0,3}((-+[ ]{0,2}){3,}|(_+[ ]{0,2}){3,}|(\*+[ ]{0,2}){3,})$/;
	public static var ULITEM = ~/^([ ]{0,3})[*+-][ \t]+(.*)$/;
	public static var OLITEM = ~/^([ ]{0,3})\d+\.[ \t]+(.*)$/;
	public static var TASK = ~/^- \[([ xX])\] (.*)$/;
	public static var CODEBLOCK = ~/^```(\S*)?\s*$/;
	public static var BLOCKQUOTE = ~/^[ ]{0,3}>[ ]?(.*)$/;

	public static var TR = ~/^[\|]?([^|]+[\|].*[^\|]+)[\|]?$/;
	public static var TB = ~/^[\|]?(\s*:?-+:?\s*[\|].*[^\|]+)[\|]?$/;

	public static var ID=~/^\[([^\]]+)\]: (\S+)( "([^"]+)")?$/;

	public static var PAGEBREAK = ~/^[%]+\S*$/;
//INLINE
	public static var HTML = ~/(<[^>]*>)/;
	public static var BR = ~/([ ]{2})$/;
	public static var STROKE = ~/(\*|_){2}(.*?)\1{2}/;
	public static var STRIKE = ~/~{2}(.*?)\1{2}/;
	public static var EMPHASYS = ~/(\*|_)(.*?)\1/;
	public static var CODE = ~/`([^`]*)`/;
	public static var LINK = ~/\[([^\]]+)\]\(([^)\s]+)( "([^"]+)")?\)/;
	public static var LINKID = ~/\[([^\]]+)\][ ]?\[([^\]]+)\]/;
	public static var LINKIDSELF = ~/\[([^\]]+)\]/;
	public static var IMAGE=~/!\[alt ([^\]]+)\]\((\S+)( "([^"]*)")?\)/i;
	public static var IMAGEID = ~/!\[alt ([^\]]+)\][ ]?\[([^)\s]+)\]/;
	public static var CELL = ~/(\|)?([^\|]+)(\|)?/;

	public static var ids:Map<String,Array<String>>=new Map();

	public static function setId(key:String,datas:Array<String>){
		key=StringTools.trim(key.toLowerCase());
		ids.set(key,datas);
	}

	public static function getId(key:String){
		key=StringTools.trim(key.toLowerCase());
		return ids.get(key);
	}



	public static function parse(text:String):Section{

		var section=new Section("MAIN");
		var datas=parseLines( text );

	//	recherche des données par ID

	for(n in 0...datas.length){
		if(datas[n][0]=="ID"){
			var key=datas[n][1];
			var vals=[datas[n][2]];
			if(datas[n][3]!=null){vals.push(datas[n][3]);} 
			setId( key , vals);
		}
	}

	return parseDatas( datas,section);

	}

//Construction de l'arborescense des données

	public static function parseDatas(datas:Array<Array<String>>,section:Section){


		for(n in 0...datas.length){

			parseData(datas[n],section);
		}

		return section;

	}


	public static function parseData(data:Array<String>,section:Section){



		switch(data[0]){

	//inline
	case "EMPTY":
	section.lastOrNew( "EMPTY");	
	case "STROKE":
	parseDatas( parseText( data[1] ),section.justNew( "STROKE" ));
	case "EMPHASYS":
	parseDatas( parseText( data[1] ),section.justNew( "EMPHASYS" ));
	case "HTML":
	section.justNew( "HTML",data[1] );
	case "CODE":
	section.justNew( "CODE",data[1] );
	case "BR":
	section.justNew( "BR");
	case "HR":
	section.justNew( "HR");
	case "PAGEBREAK":
	section.justNew( "PAGEBREAK");
	case "HEADER":
	parseDatas( parseText( data[2] ),section.justNew( "H"+data[1] ));
	case "TASK":
	var section_task=section.justNew( "TASK");
	section_task.addAttribut("task", data[2] );
	section_task.addAttribut("state", data[1] );
	case "LINK":
	var section_link=section.justNew( "LINK");
	parseDatas( parseText( data[1] ), section_link);
	section_link.addAttribut("url", data[2] );
	if(data[3]!=null){section_link.addAttribut("title", data[3]);}

	case "LINKID":
	var section_linkid=section.justNew( "LINK"); 
	var dataId=[];

	if(data[2]!=null){ dataId=getId(data[2]);}


	parseDatas( parseText( data[1] ), section_linkid);

	if(dataId!=null&&dataId[0]!=null){section_linkid.addAttribut("url", dataId[0] );}
	if(dataId!=null&&dataId[1]!=null){section_linkid.addAttribut("title", dataId[1]);}

	case "LINKIDSELF":

	var section_linkidself=section.justNew( "LINK"); 
	var dataId=[];

	if(data[1]!=null){ dataId=getId(data[1]);}

	parseDatas( parseText( data[1] ), section_linkidself);

	if(dataId!=null&&dataId[0]!=null){section_linkidself.addAttribut("url", dataId[0] );}else{section_linkidself.addAttribut("url", data[1] );}



	case "IMAGE":
	var section_image=section.justNew( "IMAGE"); 
	section_image.addAttribut( "src",data[2]);
	section_image.addAttribut( "alt",data[1]);
	if(data[3]!=null){section_image.addAttribut( "title",data[3]);}	


	case "IMAGEID":
	var section_imageid=section.justNew( "IMAGE"); 
	section_imageid.addAttribut( "alt",data[1]);

	var dataId=getId(data[2]);

	if(dataId!=null&&dataId[0]!=null){section_imageid.addAttribut("src", dataId[0] );}
	if(dataId!=null&&dataId[1]!=null){section_imageid.addAttribut("title", dataId[1]);}

	//block
	case "PARA":
	parseDatas( parseText( data[1] ), section.lastOrNew("PARA"));
	case "TEXT":
	var section_text=section.lastOrNew("TEXT");
	section_text.setContent( section_text.getContent()+data[1] );
	case "CODEBLOCK":
	var section_code=section.justNew("CODEBLOCK");
	if(data[1]!=""){section_code.addAttribut( "language",data[1]);}
	section_code.setContent( data[2] );
	case "BLOCKQUOTE":
	var section_blockquote=section.justNew("BLOCKQUOTE");			
	parseDatas( parseLines( data[1]  ),section_blockquote);
	case "LISTINDENT":
	var section_listindent=section.justNew("LISTINDENT");
	section_listindent.setContent( data[1] );
	case "ULITEM":
	var section_ul=section.lastOrNew("UL");

	var section_ulitem=section_ul.justNew("ULITEM");

	data[2]= ~/\n\n/g.replace(data[2], '\n');
	if(data[2].split("\n").length>1){
	parseDatas( parseLines( data[2]  ),section_ulitem);
	}else{parseDatas( parseText( data[2] ), section_ulitem);}
	case "OLITEM":
	var section_ol=section.lastOrNew("OL");
	
	var section_olitem=section_ol.justNew("OLITEM");

	
	if(data[2].split("\n").length>1){
		parseDatas( parseLines( data[2]  ),section_olitem);
		}else{parseDatas( parseText( data[2] ), section_olitem);}

	case "TB":
	var section_table=section.justNew("TB");
	section_table.setContent(data[1]);

	case "TR":
	var section_table=section.lastOrNew("TABLE");
	var section_tbody=section_table.lastOrNew("TBODY");
	var section_tr=section_tbody.justNew("TR");
	var cels=data[1].split("|");
	var als=data[2].split("|");
	for(n in 0...cels.length){
		var section_td=section_tr.justNew("TD");
		var t=~/\s*$/.replace(cels[n],'');
		if(als[n]!=null){

			switch(als[n]){
				case ":-":
				section_td.addAttribut("align","left");
				case "-:":
				section_td.addAttribut("align","right");
				case ":-:":
				section_td.addAttribut("align","center");
			}

		}
			parseDatas( parseText( t ), section_td);
	}


	case "TH":
	var section_table=section.lastOrNew("TABLE");
	var section_thead=section_table.lastOrNew("THEAD");
	var section_tr=section_thead.justNew("TR");
	var cels=data[1].split("|");
	var als=data[2].split("|");
	for(n in 0...cels.length){
		var section_th=section_tr.justNew("TH");
		var t=~/\s*$/.replace(cels[n],'');
		if(als[n]!=null){

			switch(als[n]){
				case ":-":
				section_th.addAttribut("align","left");
				case "-:":
				section_th.addAttribut("align","right");
				case ":-:":
				section_th.addAttribut("align","center");
			}

		}
		parseDatas( parseText( t ), section_th);
	}


	}


	}

//informations sur l'appartenance des lignes aux type de blocs

	public static function parseLines(text:String):Array<Array<String>>{



		text= ~/\r/g.replace(text, '');


		var datas:Array<Array<String>>=[];


		var data:Array<String>=[];
		var line:String="";	
		var inLines:Array<String> =text.split("\n");

	

		var pushIt:Bool=true;

		var lastData:Array<String>=["START"];
		var nextData:Array<String>=parseLine(inLines[0]);

		for(n in 0...inLines.length){ 
			line=inLines[n];
			pushIt=true;


			data=nextData;

			if(n<inLines.length-1){	nextData=parseLine(inLines[n+1]);}else{nextData=["END"];}




			if(lastData[0]=="EMPTY"){

				if(data[0]=="TR"){

					if(nextData[0]!="TB"){ data[0]="PARA";}

				}



			}



	//Blockquotes

		if(lastData[0]=="BLOCKQUOTE"){

			if(data[0]=="BLOCKQUOTE"){line=data[1];}

			var end=(nextData[0]!="BLOCKQUOTE"&&nextData[0]!="EMPTY")&&data[0]=="EMPTY";

			if(!end){
				datas[datas.length-1][1]=datas[datas.length-1][1]+"\n"+line;
				pushIt=false;
			}

			
		}



	//Codes block


		if(lastData[0]=="CODEBLOCK"){

			var end=(data[0]=="CODEBLOCK");

			
			if(!end){
				if(lastData[2]!=null){line=lastData[2]+"\n"+line;}
				datas[datas.length-1][2]=line;
				data=datas[datas.length-1];
				pushIt=false;
				}else{data[0]="EMPTY";}
		}




		if(lastData[0]=="CODEINDENT"){

			if(data[0]=="CODEINDENT"){

				datas[datas.length-1][1]=datas[datas.length-1][1]+"\n"+data[1];
				pushIt=false;
				}else{
					datas[datas.length-1][0]="CODEBLOCK";
					datas[datas.length-1][2]=datas[datas.length-1][1];
					datas[datas.length-1][1]="";
				}

		}

	//List

		if(lastData[0]=="ULITEM"){

			var isNewListItem:Bool=(data[0]=="OLITEM"||data[0]=="ULITEM")&&(data[1]<=lastData[1]);


			var end=isNewListItem||(data[0]=="EMPTY")&&((nextData[0]!="EMPTY")&&(nextData[0]!="LISTINDENT"));
			

			if(!end){

				if(data[0]=="LISTINDENT"){line=data[1];}
				datas[datas.length-1][2]=datas[datas.length-1][2]+"\n"+line;

				pushIt=false;
			}

		}

		if(lastData[0]=="OLITEM"){

			var isNewListItem:Bool=(data[0]=="OLITEM"||data[0]=="ULITEM")&&(data[1]<=lastData[1]);


			var end=isNewListItem||(data[0]=="EMPTY")&&((nextData[0]!="EMPTY")&&(nextData[0]!="LISTINDENT"));
			

			if(!end){

				if(data[0]=="LISTINDENT"){line=data[1];}
				datas[datas.length-1][2]=datas[datas.length-1][2]+"\n"+line;

				pushIt=false;
			}

			

		}

		if(lastData[0]=="TB"){

			if(data[0]=="TR"){data[2]=lastData[2];datas.pop();}
		}



		if(lastData[0]=="TH"){

			if(data[0]=="TR"){data[2]=lastData[2];}
		}


		if(lastData[0]=="TR"){

			if(data[0]=="TB"){data[0]="TH";data[1]=lastData[1];datas.pop();}
			if(data[0]=="TR"){data[2]=lastData[2];}

		}


		if(lastData[0]=="PARA"){

			if(data[0]=="PARA"){datas.push(["PARA"," "]);}
		}



		//Header setext detection

		if(data[0]=="SETEXT"){

			if(lastData[0]!="PARA"){
				data=["HR"];
				}else{
					data[0]="HEADER";
					data[2]=lastData[1];
					datas.pop();
			}

		}


		if(pushIt){datas.push(data);lastData=data;}

		}

	return datas;
	}


	private static function parseLine(line:String):Array<String>{

		

		var tab:Array<String>=[];


		if(CODEBLOCK.match(line)){
			tab.push("CODEBLOCK");
			tab.push(CODEBLOCK.matched(1));
			
			return tab;
		}




		if(CODEINDENT.match(line)){
			tab.push("CODEINDENT");
			if(CODEINDENT.matched(2)==null){tab.push("");}else{
				tab.push(CODEINDENT.matched(2));
			}
			return tab;
		}

		if(EMPTY.match(line)){
			tab.push("EMPTY");
			return tab;
		}

		if(TASK.match(line)){
			tab.push("TASK");
			if(TASK.matched(1)==" "){tab.push("0");}else{tab.push("1");}
			tab.push(TASK.matched(2));
			return tab;
		}


		if(ULITEM.match(line)){

			tab.push("ULITEM");
			var l=Std.string(ULITEM.matched(1).length);
			tab.push(l);
			tab.push(ULITEM.matched(2));
			return tab;
		}
		if(OLITEM.match(line)){
			tab.push("OLITEM");
			var l=Std.string(OLITEM.matched(1).length);
			tab.push(l);
			tab.push(OLITEM.matched(2));
			return tab;
		}


		if(LISTINDENT.match(line)){
			tab.push("LISTINDENT");
			tab.push(LISTINDENT.matched(2));
			return tab;
		}



		if(BLOCKQUOTE.match(line)){
			tab.push("BLOCKQUOTE");
			tab.push(BLOCKQUOTE.matched(1));
			return tab;

		}



		if(TB.match(line)){

			tab.push("TB");
			var t=TB.matched(1);
			t=~/[^:\-|]/g.replace(t, '');
			t=~/-+/g.replace(t, '-');
			tab.push("");
			tab.push(t);
			return tab;
		}

		if(TR.match(line)){
			tab.push("TR");
			var t=TR.matched(1);
			tab.push(t);
			tab.push("");
			return tab;
		}

		if(ATX_HEADER.match(line)){
			tab.push("HEADER");
			var l=Std.string(ATX_HEADER.matched(1).length);
			tab.push(l);
			tab.push(ATX_HEADER.matched(2));
			return tab;
		}
		if(SETEXT_HEADER.match(line)){
			tab.push("SETEXT");
			if(SETEXT_HEADER.matched(1).substr(0, 1)=="="){tab.push("1");}else{tab.push("2");}		
			return tab;
		}
		
		if(HR.match(line)){
			tab.push("HR");
			return tab;
		}

		if(PAGEBREAK.match(line)){
			tab.push("PAGEBREAK");
			return tab;
		}

		if(ID.match(line)){

			tab.push("ID");
			tab.push(ID.matched(1));
			tab.push(ID.matched(2));
			if(ID.matched(4)!=null){
				tab.push(ID.matched(4));
			}
			return tab;
		}
		tab.push("PARA");
		tab.push(line);
		return tab;
	}



//decoupage des lignes par type information

	public static function parseText(text:String):Array<Array<String>>{



		var datas:Array<Array<String>>=[];
		datas.push(["TEXT",text]);

		if(BR.match(datas[0][1])){datas[0][1]=BR.matchedLeft();datas.push(["BR"]);}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(CODE.match(datas[n][1]))){
				var l=["CODE"];
				l.push(CODE.matched(1));
				if(CODE.matchedLeft()!=""){datas[n]=["TEXT",CODE.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(CODE.matchedRight()!=""){datas.insert(n+1,["TEXT",CODE.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(HTML.match(datas[n][1]))){
				var l=["HTML"];
				l.push(HTML.matched(1));
				if(HTML.matchedLeft()!=""){datas[n]=["TEXT",HTML.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(HTML.matchedRight()!=""){datas.insert(n+1,["TEXT",HTML.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(IMAGE.match(datas[n][1]))){
				var l=["IMAGE"];
				l.push(IMAGE.matched(1));
				l.push(IMAGE.matched(2));
				if(IMAGE.matched(4)!=null){l.push(IMAGE.matched(4));}
				if(IMAGE.matchedLeft()!=""){datas[n]=["TEXT",IMAGE.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(IMAGE.matchedRight()!=""){datas.insert(n+1,["TEXT",IMAGE.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(IMAGEID.match(datas[n][1]))){
				var l=["IMAGEID"];
				if(IMAGEID.matched(1)!=null){l.push(IMAGEID.matched(1));}
				if(IMAGEID.matched(2)!=null){l.push(IMAGEID.matched(2));}
				
				if(IMAGEID.matchedLeft()!=""){datas[n]=["TEXT",IMAGEID.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(IMAGEID.matchedRight()!=""){datas.insert(n+1,["TEXT",IMAGEID.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(LINKID.match(datas[n][1]))){
				
				var l=["LINKID"];
				if(LINKID.matched(1)!=null){l.push(LINKID.matched(1));}
				if(LINKID.matched(2)!=null){l.push(LINKID.matched(2));}

				if(LINKID.matchedLeft()!=""){datas[n]=["TEXT",LINKID.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(LINKID.matchedRight()!=""){datas.insert(n+1,["TEXT",LINKID.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(LINK.match(datas[n][1]))){
				var l=["LINK"];
				l.push(LINK.matched(1));
				l.push(LINK.matched(2));
				if(LINK.matched(4)!=null){l.push(LINK.matched(4));}
				if(LINK.matchedLeft()!=""){datas[n]=["TEXT",LINK.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(LINK.matchedRight()!=""){datas.insert(n+1,["TEXT",LINK.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(LINKIDSELF.match(datas[n][1]))){
				
				var l=["LINKIDSELF"];
				if(LINKIDSELF.matched(1)!=null){l.push(LINKIDSELF.matched(1));}


				if(LINKIDSELF.matchedLeft()!=""){datas[n]=["TEXT",LINKIDSELF.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(LINKIDSELF.matchedRight()!=""){datas.insert(n+1,["TEXT",LINKIDSELF.matchedRight()]);}
			}
			n++;
		}
		
		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(STROKE.match(datas[n][1]))){
				var l=["STROKE"];
				l.push(STROKE.matched(2));
				if(STROKE.matchedLeft()!=""){datas[n]=["TEXT",STROKE.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(STROKE.matchedRight()!=""){datas.insert(n+1,["TEXT",STROKE.matchedRight()]);}
			}
			n++;
		}
		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(EMPHASYS.match(datas[n][1]))){
				var l=["EMPHASYS"];
				l.push(EMPHASYS.matched(2));
				if(EMPHASYS.matchedLeft()!=""){datas[n]=["TEXT",EMPHASYS.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(EMPHASYS.matchedRight()!=""){datas.insert(n+1,["TEXT",EMPHASYS.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(CODE.match(datas[n][1]))){
				var l=["CODE"];
				l.push(CODE.matched(1));
				if(CODE.matchedLeft()!=""){datas[n]=["TEXT",CODE.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(CODE.matchedRight()!=""){datas.insert(n+1,["TEXT",CODE.matchedRight()]);}
			}
			n++;
		}

		var n=0;
		while(n<datas.length){
			if((datas[n][0]=="TEXT")&&(STRIKE.match(datas[n][1]))){
				var l=["STRIKE"];
				l.push(STRIKE.matched(1));
				if(STRIKE.matchedLeft()!=""){datas[n]=["TEXT",STRIKE.matchedLeft()];n=n+1;datas.insert(n,l);}else{datas[n]=l;}
				if(STRIKE.matchedRight()!=""){datas.insert(n+1,["TEXT",STRIKE.matchedRight()]);}
			}
			n++;
		}

		return datas;
	}
}