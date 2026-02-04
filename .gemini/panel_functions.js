// Generate panel grid based on HP
window.generatePanelGrid = (hp) => {
    const rules = { '3': 6, '5': 9, '7.5': 13, '10': 16 };
    const expectedCount = rules[hp] || 0;

    if (!expectedCount) {
        document.getElementById('panelsGridContainer').innerHTML = '<p style="color:#999;">Please select Pump HP first.</p>';
        return;
    }

    scannedData.expectedPanels = expectedCount;
    scannedData.panels = Array(expectedCount).fill(null).map((_, i) => ({ qr: '', index: i }));

    const container = document.getElementById('panelsGridContainer');
    container.innerHTML = '';

    for (let i = 0; i < expectedCount; i++) {
        const panelBox = document.createElement('div');
        panelBox.className = 'panel-box';
        panelBox.id = `panel_${i}`;
        panelBox.style.cssText = 'background:#f9f9f9; border:2px dashed #ddd; border-radius:8px; padding:15px; margin-bottom:10px;';

        panelBox.innerHTML = `
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:10px;">
                <strong style="color:#333;">Panel ${i + 1}</strong>
                <span id="panel_${i}_status" style="font-size:12px; color:#999;">⏳ Pending</span>
            </div>
            <input type="text" id="panel_${i}_input" placeholder="Type or Scan Serial No" 
                style="width:100%; padding:8px; border:1px solid #ddd; border-radius:6px; margin-bottom:8px;"
                onchange="handlePanelInput(${i})">
            <div style="display:flex; gap:8px;">
                <button class="btn btn-secondary" onclick="scanPanelQR(${i})" style="flex:1; padding:8px; font-size:13px;">📷 Scan</button>
                <button class="btn btn-primary" onclick="scanPanelAI(${i})" 
                    style="flex:1; padding:8px; font-size:13px; background: linear-gradient(135deg, #89f7fe 0%, #66a6ff 100%); color:#005c97; border:none;">✨ AI</button>
            </div>
        `;

        container.appendChild(panelBox);
    }

    // Show finish button
    document.getElementById('finishPanelsBtn').style.display = 'block';
    document.getElementById('panelCounter').style.display = 'block';
    updatePanelProgress();
};

// Handle manual input for a panel
window.handlePanelInput = (index) => {
    const input = document.getElementById(`panel_${index}_input`);
    const serial = input.value.trim();

    if (!serial) return;

    // Check for duplicates
    const isDuplicate = scannedData.panels.some((p, i) => i !== index && p.qr === serial);

    if (isDuplicate) {
        alert(`⚠️ Duplicate Serial!\nThis serial number is already used in another panel.`);
        input.value = '';
        input.style.borderColor = 'red';
        setTimeout(() => input.style.borderColor = '#ddd', 2000);
        return;
    }

    // Save panel data
    scannedData.panels[index].qr = serial;

    // Update UI
    document.getElementById(`panel_${index}_status`).innerHTML = '✅ <span style="color:green;">Done</span>';
    document.getElementById(`panel_${index}`).style.borderColor = '#28a745';
    document.getElementById(`panel_${index}`).style.background = '#e8f5e9';
    input.disabled = true;

    updatePanelProgress();
    saveDraft();
};

// Scan panel with QR scanner
window.scanPanelQR = async (index) => {
    alert('QR Scanner integration - TBD');
    // This would trigger html5-qrcode for this specific panel
};

// Scan panel with AI
window.scanPanelAI = async (index) => {
    alert('AI Scanner integration - TBD');
    // This would trigger Gemini AI for this specific panel
};

// Update panel progress counter
window.updatePanelProgress = () => {
    const filled = scannedData.panels.filter(p => p.qr).length;
    const expected = scannedData.expectedPanels;

    const counter = document.getElementById('panelCounter');
    counter.textContent = `${filled} / ${expected}`;

    if (filled === 0) {
        counter.style.color = '#999';
        counter.style.background = '#f5f5f5';
    } else if (filled < expected) {
        counter.style.color = '#0d47a1';
        counter.style.background = '#e3f2fd';
    } else if (filled === expected) {
        counter.style.color = '#2e7d32';
        counter.style.background = '#c8e6c9';
        document.getElementById('panelsStatus').className = 'status-icon status-done';
    }
};
