// See README.md for license details.

ThisBuild / scalaVersion := "2.13"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "com.github.lassenorbjerg"

// 5.3.0 is required for ip-contributions
val chiselVersion = "5.3.0"

scalacOptions ++= Seq(
  "-deprecation",
  "-feature",
  "-unchecked",
  // "-Xfatal-warnings",
  "-language:reflectiveCalls"
)

lazy val root = (project in file("."))
  .settings(
    name := "fpga-reverb",
    addCompilerPlugin(
      "org.chipsalliance" % "chisel-plugin" % chiselVersion cross CrossVersion.full
    )
  )

libraryDependencies += "edu.berkeley.cs" %% "chisel3" % chiselVersion
libraryDependencies += "edu.berkeley.cs" %% "chiseltest" % "0.6.2"
// https://github.com/freechipsproject/ip-contributions
libraryDependencies += "edu.berkeley.cs" % "ip-contributions" % "5.3.0"
