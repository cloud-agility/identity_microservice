//Require the dev-dependencies
let chai      = require('chai');
let chaiHttp  = require('chai-http');
let server    = require('../hello');
let should    = chai.should();

chai.use(chaiHttp);
//Our parent block
describe('Hello Tests', () => {
  describe('GET /', () => {
    it('it should GET Hello World!', (done) => {
      chai.request(server)
          .get('/')
          .end( (err, res) => {
              res.should.have.status(200);
              res.body.should.have.property('message').eql("Hello World!");
              done();
          });
    });
  });
});
