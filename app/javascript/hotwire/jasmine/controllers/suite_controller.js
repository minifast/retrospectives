import { Controller } from '@hotwired/stimulus'
import jasmineRequire from 'jasmine-core/lib/jasmine-core/jasmine.js'

export default class extends Controller {
  static values = {id: String}

  initialize() {
    this.jasmine = jasmineRequire.core(jasmineRequire);
  }

  async connect() {
    const { jasmine, idValue } = this;
    const global = jasmine.getGlobal();
    global.jasmine = jasmine;
    const env = jasmine.getEnv();
    const jasmineInterface = jasmineRequire.interface(jasmine, env);

    env.addReporter(this);

    for (const property in jasmineInterface) {
      global[property] = jasmineInterface[property];
    }

    try {
      await import(idValue);
      await env.execute();
    } finally {
      env.clearReporters();
      for (const property in jasmineInterface) {
        delete global[property];
      }
    }
  }

  jasmineStarted({order, ...detail}) {
    const { idValue } = this;
    this.stack = [];
    const event = new CustomEvent('jasmine:started', {detail: {suiteId: idValue, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }

  suiteStarted({order, ...detail}) {
    const { idValue, stack } = this;
    stack.push(detail)
    const event = new CustomEvent('jasmine:suite:started', {detail: {suiteId: idValue, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }

  specStarted({order, ...detail}) {
    const { idValue, stack } = this;
    const event = new CustomEvent('jasmine:spec:started', {detail: {suiteId: idValue, stack, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }

  specDone({order, ...detail}) {
    const { idValue, stack } = this;
    const event = new CustomEvent('jasmine:spec:done', {detail: {suiteId: idValue, stack, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }

  suiteDone({order, ...detail}) {
    const { idValue, stack } = this;
    stack.pop();
    const event = new CustomEvent('jasmine:suite:done', {detail: {suiteId: idValue, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }

  jasmineDone({order, ...detail}) {
    const { idValue } = this;
    this.stack = null;
    const event = new CustomEvent('jasmine:done', {detail: {suiteId: idValue, ...detail}, bubbles: true});
    this.element.dispatchEvent(event);
  }
}
