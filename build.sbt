// See README.md for license details.

ThisBuild / scalaVersion := "2.13.18"
ThisBuild / version := "0.1.0"
ThisBuild / organization := "com.github.lassenorbjerg"

// chiseltest 0.6.2 and ip-contributions 0.6.1 are built against Chisel 3.6.x,
// so the whole stack is pinned to that generation.
val chiselVersion = "3.6.1"

lazy val root = (project in file("."))
  .settings(
    name := "fpga-reverb",
    libraryDependencies ++= Seq(
      "edu.berkeley.cs" %% "chisel3" % chiselVersion,
      "edu.berkeley.cs" %% "chiseltest" % "0.6.2" % "test",
      "edu.berkeley.cs" % "ip-contributions" % "0.6.1",
      "org.scalatest" %% "scalatest" % "3.2.15" % "test"
    ),
    scalacOptions ++= Seq(
      "-language:reflectiveCalls",
      "-deprecation",
      "-feature",
      "-Xcheckinit",
      "-Ymacro-annotations"
    ),
    addCompilerPlugin(
      "edu.berkeley.cs" % "chisel3-plugin" % chiselVersion cross CrossVersion.full
    )
  )
