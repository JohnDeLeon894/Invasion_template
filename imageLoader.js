const fs = require('fs')
const path = require('path')

function makeList () {
  // read fils in image folder save list to variable
  const fileNames = fs.readdirSync('./images',{ encoding: 'utf-8'})

  const selectFileNames = []
  fileNames.map((fileName, i) => {
    // if(fileName.includes('desertFoto')){
      selectFileNames.push((`images ${fileName}`))
    // }
  })
  // count number of items in list
  const fileCount = fileNames.length

  // pass items to string template
  const result = `__EVAL(${JSON.stringify(selectFileNames)}select round random ${fileCount});`
  console.log('fileCount', result)
}

makeList()