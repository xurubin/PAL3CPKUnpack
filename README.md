#仙剑3　CPK文件格式分析及完美提取器！
经过2天的努力，总算写成了这个CPK提取器！经测试，它在仙剑3中工作得很好，我估计在外传中使用问题也不大，因为毕竟游戏引擎没有太大的变化。

.CPK应该是是软星自己写的文件格式，不过我在网上查找相关资料时意外的发现了一个叫风魂的游戏，我估计软星的程序员一定研究过这个游戏，因为两者的数据存储方式惊人地相同，软星只改变了一些小地方（如文件头部）。两者同样采用MiniLZO快速压缩算法，采用排过序的CRC作为ID以方便使用二分搜索来快速定位文件等等，下面我就来简单介绍一下，其实我对文件的分析很不完全，好多地方我并不清楚，不过这些初步成果已经足够写一个CPK提取器了。

CPK文件格式简介
文件头0x80字节为CPK的基本信息，其中头4字节为CPK文件标志：0x52 0x53 0x 54 0x1A，从0x80开始是一个类似于硬盘FAT的结构，由若干个 struct构成（我称之为索引，下面会详细讨论）最后才是数据区，CPK中存储的所有的文件都经过MiniLZO压缩。

索引结构：
```
Type 
   Index=record
	CRC		:DWORD;
	Attrib		:DWORD;
	ParentDir	:DWORD;
	Offset		:DWORD;
	CompressedSize	:DWORD;
	OriginalSize	:DWORD;
	InfoRecordSize	:DWORD;(???????????)
```
每个Index代表一个文件（目录也是一种文件），占0x1C个字节，从CPK的0x80开始紧密排列。Index结构的总数存储在CPK的0x20处，是一个DWORD
下面我来一一做出解释：
* CRC：据我猜测应该是根据文件名Hash出的一个数值，若干个Index结构在CPK文件中就是按这个数值升序排列的。这样的好处是只要计算出要访问文件的CRC，就可以利用二分查找在对数时间内定位该文件的Index，进而读取数据。
* Attrib：该文件的属性，我只知道00000003代表目录，其他的都不太清楚，不过这已经足够了。
* ParentDir：一个CRC值，等于它的父目录的CRC。CPK文件支持子目录，当你定位好一个文件的index后，通过这个指针反复向上层遍历，就可以取得它的完整的存储路径。在根目录下的文件的Index中此值为0。
* Offset：压缩后的数据在CPK中的偏移量。
* CompressedSize：压缩后数据的大小。对于目录，这个值为0。
* OriginalSize：原始文件的大小，方便你解压时开缓冲区。
* InfoRecordSize：奇怪的参数。对于每一个Index所代表的文件，压缩后的数据在CPK中从index.Offset起开始存储，占用index.CompressedSize的空间，接下来就是一个大小为InfoRecordSize的奇怪记录，我只知道这个记录的一开头就是文件名，以#0结束，其他的都不清楚，有兴趣的可以研究一下。
需要注意的是，只要InfoRecordSize为0，或这个Index不是目录，但CompressedSize为0，这个Index就毫无疑义，不需处理。我因为多次运行升级程序（为了调试它来研究CPK格式），文件中已有好多这样的无效Index了。

## MiniLZO解压：
我不想研究这种东西了，让GbEngine.dll自己做去吧。看看他的ExportTable，发现有这么一行：
```
?DeCompress@CPK@@QAEKPAX0K@Z
```
翻译过来就是
```
public: unsigned long __thiscall CPK::DeCompress(void *,void *,unsigned long)
```
实际上是
```
function DeCompress(Dest,Source:pointer;SourceSize:integer):integer;stdcall;
```
这下就大功告成了。

### 附1：我写的CPK Extracter
本程序必须放在仙剑3根目录下（即要有ijl15.dll　topo.dll　gbengine.dll　Mss32.dll这些文件）原因如上。

### 附2：仙剑3音乐标题
我是根据音乐选集上的名称再加上网上试听后找出来的，只有24个，那位好心人如有剩下的一定要写出来哦

PI01.MP3御剑江湖  
PI05.MP3凄凉雪  
PI08.MP3流转虹  
PI09.MP3月迷纵  
PI10.MP3紫陌丰田   
PI11.MP3临江仙   
PI12.MP3望海潮   
PI13.mp3降妖谱   
PI15.MP3洞天福地   
PI16.MP3紫鸦乌   
PI17.MP3沧桑叹   
PI19.MP3铁锁镇妖  
PI20.MP3魔神诀  
PI21.MP3步云登仙  
PI24.MP3仗剑  
PI25.MP3临危  
PI26.MP3魔剑斩妖  
PI27.MP3玉满堂  
PI28A.MP3还魂草  
PI30.MP3水柔声  
PI31.MP3青玉案  
PI32.MP3玄色风  
PI33.MP3情牵  
PI34.MP3轮回  

