const initStatsWeightModifier = (
  id,
  {
    minWeight,
    maxWeight,
    defaultWeight,
    defaultStat,
    step,
  },
) => {
  const select = document.getElementById(id);
  const weightsState = {};

  const getStatName = (option) => option.querySelector('.text').textContent;

  const sendStateToShiny = () => {
    Shiny.setInputValue(`${id}-stats_weights`, { weights: weightsState });
  };

  const updateWeight = (e, statName, action, step = 1) => {
    e.stopPropagation();
    const currentValue = weightsState[statName];
    const valueNode = e.target.parentNode.querySelector('.weight-value');
    let newValue;

    if (action === 'increase') {
      newValue = currentValue < maxWeight ? currentValue + step : maxWeight;
    } else if (action === 'decrease') {
      newValue = currentValue > minWeight ? currentValue - step : minWeight;
    }
    weightsState[statName] = newValue;
    valueNode.textContent = parseFloat(newValue.toFixed(2));
    sendStateToShiny();
    return newValue;
  };

  const updateControlButtons = (button, action, newWeightValue) => {
    const buttons = [...button.parentNode.querySelectorAll('.control-btn')];
    const oppositeButton = buttons.find((btn) => btn !== button);

    if (action === 'increase') {
      if (newWeightValue === maxWeight) button.classList.add('disabled');
    } else if (action === 'decrease') {
      if (newWeightValue === minWeight) button.classList.add('disabled');
    }
    oppositeButton.classList.remove('disabled');
  };

  const controlButton = (statName, action, step) => {
    const button = document.createElement('button');
    button.className = 'btn btn-outline-primary control-btn';
    button.classList.add(action);
    button.textContent = action === 'increase' ? '+' : '-';
    button.addEventListener(
      'click',
      (e) => {
        const newWeightValue = updateWeight(e, statName, action, step);
        updateControlButtons(button, action, newWeightValue);
      },
    );
    return button;
  };

  const weightValue = (statName) => {
    const valueNode = document.createElement('span');
    valueNode.className = 'weight-value';
    valueNode.textContent = weightsState[statName]
      ? weightsState[statName]
      : defaultWeight;
    return valueNode;
  };

  const weightModifier = (statName, step) => {
    const modifier = document.createElement('div');
    modifier.className = 'weight-modifier';
    modifier.addEventListener('click', (e) => e.stopPropagation());
    modifier.append(
      controlButton(statName, 'decrease', step),
      weightValue(statName),
      controlButton(statName, 'increase', step),
    );
    return modifier;
  };

  const addWeightModifiers = (option, step) => {
    const modifier = option.querySelector('.weight-modifier');
    const statName = getStatName(option);
    if (weightsState[statName] === undefined) weightsState[statName] = defaultWeight;
    if (!modifier) option.appendChild(weightModifier(statName, step));
  };

  const removeWeightModifiers = (option) => {
    const modifier = option.querySelector('.weight-modifier');
    const statName = getStatName(option);
    if (modifier) option.removeChild(modifier);
    if (weightsState[statName] !== undefined) delete weightsState[statName];
  };

    const handleWeightsVisibility = (option, initial = false) => {
    if (option.classList.contains('selected') || initial) {
      addWeightModifiers(option, step);
    } else {
      removeWeightModifiers(option);
    }
  };

  select.addEventListener('change', () => {
    const options = select.parentNode.querySelectorAll('.dropdown-item.opt');
    [...options].forEach((option) => handleWeightsVisibility(option));
    sendStateToShiny();
  });

  // TODO: Change from jquery to vanilla js
  $(select).on('show.bs.select', () => {
    setTimeout(
      () => {
        const options = select.parentNode.querySelectorAll('.dropdown-item.opt');

        [...options].forEach((option) => {
          handleWeightsVisibility(option, getStatName(option) === defaultStat);
        });
        console.log(weightsState)
        sendStateToShiny();
      }, 0,
    );
  });
};
