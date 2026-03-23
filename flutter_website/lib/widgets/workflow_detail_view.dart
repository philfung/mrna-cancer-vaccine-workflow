import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'dart:math';
import '../providers/workflow_provider.dart';
import '../models/workflow_data.dart';

class WorkflowDetailView extends ConsumerWidget {
  const WorkflowDetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(workflowProvider);
    final currentStep = state.currentStep;
    
    // Find the primary step node for this workflow step
    WorkflowNodeData? stepNode;
    try {
      stepNode = state.nodes.firstWhere(
        (n) => n.type == NodeType.step && currentStep.nodeIds.contains(n.id),
      );
    } catch (_) {
      // Fallback if no step node is found
      stepNode = null;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border(
          left: BorderSide(
            color: const Color(0xFF2C2C2E),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(currentStep, stepNode),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stepNode != null) ...[
                    _buildSectionTitle('GOAL'),
                    _buildStepGoal(context, stepNode.goal ?? ''),
                    const SizedBox(height: 16),

                    _buildSectionTitle('PROCESS'),
                    _buildDescription(context, stepNode.description ?? ''),
                    const SizedBox(height: 16),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool isNarrow = constraints.maxWidth < 340;
                        
                        final textColumn = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle('TOOLS AND EQUIPMENT'),
                            if (stepNode!.hardware != null && stepNode.hardware != 'None')
                              _buildDetailRow(context, LucideIcons.microscope, 'Lab Equipment', stepNode.hardware!),
                            if (stepNode.software != null && stepNode.software != 'None')
                              _buildDetailRow(context, LucideIcons.code, 'Software', stepNode.software!),
                            if (stepNode.outsourced != null && stepNode.outsourced != 'None')
                              _buildDetailRow(context, LucideIcons.externalLink, 'Outsourced Alternatives', stepNode.outsourced!),
                            if (stepNode.cost != null)
                              _buildDetailRow(context, LucideIcons.dollarSign, 'Est. Cost', stepNode.cost!),
                          ],
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textColumn,
                              if (stepNode.image != null) ...[
                                const SizedBox(height: 16),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    stepNode.image!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: textColumn),
                            if (stepNode.image != null) ...[
                              const SizedBox(width: 16),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  stepNode.image!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    
                    if (stepNode.inputs != null && stepNode.inputs!.isNotEmpty) ...[
                      _buildSectionTitle('INPUTS'),
                      ...stepNode.inputs!.map((input) => _buildResourceItem(context, input, isOutput: false)),
                      const SizedBox(height: 16),
                    ],
                    
                    if (stepNode.outputs != null && stepNode.outputs!.isNotEmpty) ...[
                      _buildSectionTitle('OUTPUTS'),
                      ...stepNode.outputs!.map((output) => _buildResourceItem(context, output, isOutput: true)),
                      const SizedBox(height: 16),
                    ],

                    
                  ] else if (currentStep.id == 1) ...[
                    _buildStepGoal(context, 'Procuring Biological Starting Material'),
                    const SizedBox(height: 16),
                    _buildDescription(context, 'Two key patient samples are required to initiate the personalized mRNA vaccine manufacturing process:'),
                    const SizedBox(height: 16),
                    _buildSectionTitle('REQUIRED SAMPLES'),
                    _buildImageResourceItem(context, 'lib/assets/icons/icon_tissue.png', 'Tumor Biopsy: Provides tumor DNA & RNA to identify cancer-specific somatic mutations (neoantigens) unique to the patient.'),
                    _buildImageResourceItem(context, 'lib/assets/icons/icon_blood.png', 'Normal Blood: Serves as a healthy genetic reference to filter out inherited (germline) mutations and isolate immune cells for HLA typing.'),
                  ] else if (currentStep.id == 10) ...[
                    _buildStepGoal(context, 'Final Vaccine Formulation'),
                    const SizedBox(height: 16),
                    _buildDescription(context, 'The personalized mRNA vaccine formulation encapsulated in lipid nanoparticles.'),
                  ] else ...[
                    _buildStepGoal(context, 'Overview of required inputs and baseline data.'),
                    const SizedBox(height: 16),
                    _buildDescription(context, 'This stage prepares the necessary patient samples and reference data required for the digital pipeline.'),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(WorkflowStep step, WorkflowNodeData? stepNode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        border: Border(
          bottom: BorderSide(
            color: Color(0xFF2C2C2E),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              step.part.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF6366F1),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              step.title,
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey[500],
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildStepGoal(BuildContext context, String goal) {
    return Text(
      goal,
      style: GoogleFonts.inter(
        fontSize: min(MediaQuery.of(context).size.width * 0.05, 18),
        fontWeight: FontWeight.w600,
        color: Colors.grey[300],
        height: 1.4,
      ),
    );
  }

  Widget _buildDescription(BuildContext context, String description) {
    return MarkdownBody(
      data: description,
      styleSheet: _markdownStyle(context, GoogleFonts.inter(
        fontSize: min(MediaQuery.of(context).size.width * 0.04, 15),
        fontWeight: FontWeight.w400,
        color: Colors.grey[400],
        height: 1.6,
      )),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final url = Uri.parse(href);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        }
      },
    );
  }

  Widget _buildResourceItem(BuildContext context, WorkflowNodeInOut item, {required bool isOutput}) {
    String imagePath = 'lib/assets/icons/${item.icon}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 48, height: 48),
          const SizedBox(width: 12),
          Expanded(
            child: MarkdownBody(
              data: item.text,
              styleSheet: _markdownStyle(context, GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[300],
              )),
              onTapLink: (text, href, title) async {
                if (href != null) {
                  final url = Uri.parse(href);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageResourceItem(BuildContext context, String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: 48, height: 48),
          const SizedBox(width: 12),
          Expanded(
            child: MarkdownBody(
              data: text,
              styleSheet: _markdownStyle(context, GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[300],
              )),
              onTapLink: (text, href, title) async {
                if (href != null) {
                  final url = Uri.parse(href);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: Colors.grey[400]),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
                MarkdownBody(
                  data: value,
                  styleSheet: _markdownStyle(context, GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
                  onTapLink: (text, href, title) async {
                    if (href != null) {
                      final url = Uri.parse(href);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _markdownStyle(BuildContext context, TextStyle baseStyle) {
    return MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: baseStyle,
      pPadding: EdgeInsets.zero,
      listBullet: baseStyle,
      listIndent: 20,
      blockSpacing: 8,
      a: baseStyle.copyWith(
        color: const Color(0xFF6366F1),
        decoration: TextDecoration.underline,
        decorationColor: const Color(0xFF6366F1).withOpacity(0.5),
      ),
    );
  }
}
