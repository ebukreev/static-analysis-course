package tip.analysis

import tip.ast.AstNodeData.DeclarationData
import tip.cfg._
import tip.lattices.IntervalLattice.{MInf, PInf}
import tip.lattices._
import tip.solvers._

trait VariableSizeAnalysisWidening extends IntervalAnalysisWidening {
  override val B = Set(
    0, 1,
    Byte.MinValue,
    Byte.MaxValue,
    Char.MinValue.toInt,
    Char.MaxValue.toInt,
    Int.MinValue,
    Int.MaxValue,
    MInf,
    PInf
  )
}

object VariableSizeAnalysis {
  object Intraprocedural {
    class WorklistSolverWithWidening(cfg: IntraproceduralProgramCfg)(implicit declData: DeclarationData)
        extends IntraprocValueAnalysisWorklistSolverWithReachability(cfg, IntervalLattice)
        with WorklistFixpointSolverWithReachabilityAndWidening[CfgNode]
        with VariableSizeAnalysisWidening

    class WorklistSolverWithWideningAndNarrowing(cfg: IntraproceduralProgramCfg)(implicit declData: DeclarationData)
        extends IntraprocValueAnalysisWorklistSolverWithReachability(cfg, IntervalLattice)
        with WorklistFixpointSolverWithReachabilityAndWideningAndNarrowing[CfgNode]
        with VariableSizeAnalysisWidening {

      val narrowingSteps = 5
    }
  }
}