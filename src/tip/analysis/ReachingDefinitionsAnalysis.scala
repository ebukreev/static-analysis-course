package tip.analysis

import tip.ast._
import tip.lattices._
import tip.ast.AstNodeData.DeclarationData
import tip.ast.AstOps.AstOp
import tip.solvers._
import tip.cfg._


abstract class ReachingDefinitionsAnalysis(cfg: IntraproceduralProgramCfg)(implicit declData: DeclarationData) extends FlowSensitiveAnalysis(false) {

  val lattice: MapLattice[CfgNode, PowersetLattice[AAssignStmt]] = new MapLattice(new PowersetLattice())

  val domain: Set[CfgNode] = cfg.nodes

  NoPointers.assertContainsProgram(cfg.prog)
  NoRecords.assertContainsProgram(cfg.prog)

  def transfer(n: CfgNode, s: lattice.sublattice.Element): lattice.sublattice.Element = {
    n match {
      case _: CfgFunEntryNode => lattice.sublattice.bottom
      case r: CfgStmtNode =>
        r.data match {
          case as: AAssignStmt =>
            as.left match {
              case id: AIdentifier =>
                s.filter(
                  assign => assign.left.isInstanceOf[AIdentifier] &&
                    assign.left.asInstanceOf[AIdentifier].name != id.name) + as

              case _ => ???
            }
          case _ => s
        }
      case _ => s
    }
  }
}

class ReachingDefAnalysisSimpleSolver(cfg: IntraproceduralProgramCfg)(implicit declData: DeclarationData)
  extends ReachingDefinitionsAnalysis(cfg)
    with SimpleMapLatticeFixpointSolver[CfgNode]
    with ForwardDependencies

class ReachingDefAnalysisWorklistSolver(cfg: IntraproceduralProgramCfg)(implicit declData: DeclarationData)
  extends ReachingDefinitionsAnalysis(cfg)
    with SimpleWorklistFixpointSolver[CfgNode]
    with ForwardDependencies