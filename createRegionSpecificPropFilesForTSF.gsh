#! /usr/bin/env groovy

import groovy.io.*

dir = new File(args[0])

dir.traverse(
    type : FileType.FILES,
    nameFilter : ~/.*\.properties/,
    maxDepth : 0
 ) { propertyFile ->

  println "Processing Property File: ${propertyFile.getPath()} ..."

  Properties props = new Properties()
  props.load(new FileReader(propertyFile))
  def config = new ConfigSlurper().parse(props)

  def newDir = new File("./${config.__TS_REGION_NAME__}")

  if (!newDir.mkdir() && !newDir.exists()) {
    println "Failed to create directory: ${newDir.getPath()} !!!"
  } else {

    def rspropfile = new File(newDir, "RegionEnv.cfg")  
    initializeFile(rspropfile)
    def credfile = new File(newDir, "Credentials.cfg")
    initializeFile(credfile)
  
    rspropfile << "# Region specific properties for region: ${config.__TS_REGION_NAME__}" + '\n'
    rspropfile << " " + '\n'
    credfile << "# Region specific credentials for region: ${config.__TS_REGION_NAME__}" + '\n'
    credfile << " " + '\n'
    rspropfile << "TS_REGION_NAME = ${config.__TS_REGION_NAME__}" + '\n'
    rspropfile << "AppServerName = ${config.__AppServerName__}" + '\n'
    rspropfile << "CellName = ${config.__CellName__}" + '\n'
    rspropfile << "URLName = ${config.__URLName__}" + '\n'
    rspropfile << "TSRoot = ${config.__TSRoot__}" + '\n'
    rspropfile << "WASHome = ${config.__WASHome__}" + '\n'
    rspropfile << "SLNSPort = ${config.__SLNSPort__}" + '\n'
    rspropfile << "EmailAddress = ${config.__EmailAddress__}" + '\n'
    rspropfile << "NumberAllowedFailedPasswordAttempts = ${config.__PASSWORD_FAILED_ATTEMPTS__}" + '\n'
    credfile << "TSPROXY_USERNAME = ${config.__TSPROXY_USERNAME__}" + '\n'
    credfile << "TSPROXY_PASSWORD = ${config.__TSPROXY_PASSWORD__}" + '\n'
    rspropfile << "DatabaseServerName = ${config.__DatabaseServerName__}" + '\n'
    rspropfile << "TSDBVendor = ${config.__TSDBVendor__}" + '\n'
    rspropfile << "TSDBName = ${config.__TSDBName__}" + '\n'
    credfile << "DBUserID = ${config.__DBUserID__}" + '\n'
    credfile << "DBPasswd = ${config.__DBPasswd__}" + '\n'
    rspropfile << "DBPort = ${config.__DBPort__}" + '\n'
    rspropfile << "ArchiveDatabaseServerName = ${config.__ArchiveDatabaseServerName__}" + '\n'
    rspropfile << "ArchiveDBVendor = ${config.__ArchiveDBVendor__}" + '\n'
    rspropfile << "ArchiveDBName = ${config.__ArchiveDBName__}" + '\n'
    credfile << "ArchiveDBUserID = ${config.__ArchiveDBUserID__}" + '\n'
    credfile << "ArchiveDBPasswd = ${config.__ArchiveDBPasswd__}" + '\n'
    rspropfile << "ArchiveDBPort = ${config.__ArchiveDBPort__}" + '\n'
    rspropfile << "LIVELINK_SERVER = ${config.__LIVELINK_SERVER__}" + '\n'
    rspropfile << "LIVELINK_PORT = ${config.__LIVELINK_PORT__}" + '\n'
    rspropfile << "LIVELINK_DB = ${config.__LIVELINK_DB__}" + '\n'
    credfile << "LIVELINK_USER = ${config.__LIVELINK_USER__}" + '\n'
    credfile << "LIVELINK_PASSWORD = ${config.__LIVELINK_PASSWORD__}" + '\n'
  
    if (!config.__PRINTER_LIST__.contains('unix_printer_list')) {
      rspropfile << "# unix_printer_list[] =" + '\n\n'
    } else {
      rspropfile << "${config.__PRINTER_LIST__}" + '\n'
    }
  }

}

def initializeFile(File file) {
  if (file.exists()) {
    // Clear the file and write it again
    if (file.isFile()) { file.setText("") } 
    else {
      throw new RuntimeException(
        "Attempting to write to file that exists as directory: ${file.getPath()}")
    }
  }
}
  
System.exit(0)
