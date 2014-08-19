package m2h.markdown;

class Section{
	public var childs:Array<Section>;
	public var parent:Section;
	private var type:String;
	private var attributes:Map<String,String>;
	private var content:String;



	public function new(type:String,content:String=""){
		childs=[];
		parent=null;
		this.type=type;
		this.content=content;
		attributes=new Map();
	}

	public function addAttribut(name:String,value:String){

		attributes.set(name,value);

	}

	public function addChild(section:Section){
		childs.push(section);
		section.parent=this;
	}

	public function getLastChild(){

		if(childs.length>0){

			return childs[childs.length-1];

			}else{

				return null;
			}
		}

		public function justNew(mytype:String,content:String=""){

			var new_section=new Section(mytype,content);
			addChild(new_section);
			return new_section;
			

		}

		public function lastOrNew(mytype:String){

			if((getLastChild()!=null)&&(getLastChild().getType()==mytype)){
				return getLastChild();
				}else{
					var new_section=new Section(mytype);
					addChild(new_section);
					return new_section;
				}

			}

			public function setType(text:String){
				type=text;
			}

			public function getChilds():Array<Section>{ return childs;}
			public function getType():String{ return type;}
			public function getAttributes():Map<String,String>{ return attributes;}

			public function setContent(text:String){
				content=text;
			}
			public function getContent():String{ return content;}
			public function getAtt(k:String):String{ 
				return attributes.get(k);
			}

			public function print(level:Int=1):String{
				var atts="";
				for(k in attributes.keys()){
					atts=atts+" "+k+"="+attributes.get(k);
				}



				var text="["+type+atts+"] "+content;

				var tabulation="";
				for (n in 0...level){
					tabulation=tabulation+"\t";
				}
				for(n in 0...childs.length){
					text=text+"\n"+tabulation+childs[n].print(level+1);
				}
				return text;
			}
		}