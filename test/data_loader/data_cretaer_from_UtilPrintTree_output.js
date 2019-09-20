const fs = require("fs");
const readline = require("readline");

const lineReader = readline.createInterface({input: fs.createReadStream("input.txt")});

lineReader.on('line',(line)=>{
    line = line.replace(/\] \[/g,`","`);
    line = line.replace(/\[/g,`"`);
    line = line.replace(/\]/g,`"`);
    line = line.replace(/\|/g,`","`);
    console.log(`[${line}],`);
});