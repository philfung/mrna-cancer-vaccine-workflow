import React, { memo } from 'react';
import { Handle, Position } from 'reactflow';

const WorkflowNode = ({ data, isConnectable }) => {
  const { title, description, type, hardware, cost, color, icon: Icon, goal, outsourced } = data;

  const isStep = type === 'step';
  const isTitle = type === 'title';
  const isData = type === 'data';

  const nodeClass = `workflow-node ${type}-node ${color}-theme ${isStep ? 'step-node' : ''}`;

  return (
    <div className={nodeClass}>
      {!isTitle && (
        <Handle 
          type="target" 
          position={Position.Top} 
          isConnectable={isConnectable} 
          className="node-handle"
        />
      )}
      
      <div className="node-content">
        {isStep && (
          <div className="node-header">
            {Icon && <Icon className="node-icon" size={24} />}
            <div className="title-stack">
              <h3 className="node-title">{title}</h3>
              {goal && <div className="node-goal">Goal: {goal}</div>}
            </div>
          </div>
        )}
        
        {isData && (
          <div className="node-data-header">
             <div className="node-dot" />
             <span className="node-data-title">{title}</span>
          </div>
        )}

        {isTitle && <h2 className="node-main-title">{title}</h2>}

        <div className="node-description" dangerouslySetInnerHTML={{ __html: description }} />
        
        {isStep && (hardware || cost || outsourced) && (
          <div className="node-footer">
            {hardware && <div className="footer-item"><span>Hardware:</span> {hardware}</div>}
            {outsourced && <div className="footer-item"><span>Outsourced:</span> {outsourced}</div>}
            {cost && <div className="footer-item cost"><span>Cost:</span> {cost}</div>}
          </div>
        )}
      </div>

      {!isTitle && (
        <Handle 
          type="source" 
          position={Position.Bottom} 
          isConnectable={isConnectable} 
          className="node-handle"
        />
      )}
    </div>
  );
};

export default memo(WorkflowNode);
